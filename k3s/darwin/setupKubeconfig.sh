#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../colors.sh
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../helpers.sh
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../logger.sh -c=true

clear

CreateDirIfNotExist "$HOME/.kube/config.d"

clusterName=$1
configFile=$HOME/.kube/config.d/config_${clusterName//-/_}
configFileTmp="$(printf "%s_tmp", $configFile)"
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "get kubectl config file for cluster with name $1"`"

INFO "transfer kube config file with ssh from master node"
multipass exec "k3s-$clusterName-master-0" -- /bin/bash -c "cat /etc/rancher/k3s/k3s.yaml" > $configFile

INFO "change node IP"
export K3S_NODEIP_MASTER="$(multipass info "k3s-$clusterName-master-0" | grep "IPv4" | awk -F' ' '{print $2}'):6443"
sed -i -e 's/127.0.0.1:6443$/'$K3S_NODEIP_MASTER'/g' $configFile

INFO "create admin SA, ClusterRoleBinding"
secretName="cluster-service-account"
cat <<EOF | kubectl apply --kubeconfig $configFile -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cluster-service-account
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: cluster-service-account
  namespace: kube-system
---
apiVersion: v1
kind: Secret
metadata:
  name: $secretName
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: cluster-service-account
type: kubernetes.io/service-account-token
EOF

INFO "get token from SA secret $secretName"
tokenData=$(kubectl --kubeconfig $configFile get secret ${secretName} \
  --namespace kube-system \
  -o jsonpath='{.data.token}')

token=$(echo ${tokenData} | base64 -d)
INFO "token is: $token"

INFO "minify"
kubectl --kubeconfig $configFile \
  config view --flatten --minify | tr -s '\n' | uniq > $configFileTmp
cat $configFileTmp

INFO "rename context"
kubectl config --kubeconfig $configFileTmp \
  rename-context $(kubectl config current-context) $clusterName

INFO "create token user"
kubectl config --kubeconfig $configFileTmp \
  set-credentials $(kubectl config current-context)-token-user \
  --token ${token}

INFO "create cluster"
kubectl config --kubeconfig $configFileTmp \
  set-cluster $(kubectl config current-context)-token-cluster \
  --token ${token}

INFO "set context to use token user"
kubectl config --kubeconfig $configFileTmp \
  set-context $clusterName --user $(kubectl config current-context)-token-user

INFO "set context to correct namespace"
kubectl config --kubeconfig $configFileTmp \
  set-context $clusterName --cluster default

INFO "merge 2 kube config file"
echo "" > $configFile
Kmerge $configFileTmp $(basename -- $configFile) "$HOME/.kube/config.d"

INFO "cat new kube config file: $configFile"
cat $configFile
rm -f $configFileTmp

if [ "$2" = true ]; then
  env=$(printf "export KUBECONFIG=%s:$HOME/.kube/config\n" $configFile)

  if [[ -f "$HOME/.zshrc" ]]; then
      YellowStr "setup: $HOME/.zshrc\n"
      echo "$env" | sudo tee -a "$HOME"/.zshrc
  fi

  if [[ -f "$HOME/.bashrc" ]]; then
    YellowStr "setup: $HOME/.bashrc\n"
    echo "$env" | sudo tee -a "$HOME"/.bashrc
  fi

  export KUBECONFIG="$configFile:$HOME/.kube/config"

  kubectl config set-context $clusterName
  kubectl config use-context $clusterName
fi

YellowStr "terminal type: `GetTerminalType`\n"

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "check new kube config file working"`"
kubectl get pods --context=$clusterName
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "completed"`"