#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../colors.sh
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../logger.sh -c=true

clear
printf "%s\n" `RepeatColorStr ${Green} '*' 90`
INFO "Create a K3S-cluster with name `YellowStr "$1"` with `YellowStr "$2"` worker and 1 master nodes"
export CL_NAM=$1
export NUM_WORKERS=$2
export CPU_MASTERS=$3
export CPU_WORKERS=$4
export RAM_MASTERS=$5
export RAM_WORKERS=$6
export DRIVE_MASTERS=$7
export DRIVE_WORKERS=$8

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "launch master"`"
multipass launch ubuntu -n k3s-$CL_NAM-master-0 -v -c $CPU_MASTERS -d $DRIVE_MASTERS -m $RAM_MASTERS

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "update master"`"
multipass exec k3s-$CL_NAM-master-0 sudo apt-get update

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "upgrade master"`"
multipass exec k3s-$CL_NAM-master-0 -- /bin/bash -c "sudo apt-get upgrade --assume-yes"

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "mount master"`"
mkdir -p store
mkdir -p store/k3s-$CL_NAM-master-0
multipass mount -v -u 502:1000 -g 20:1000 store/k3s-$CL_NAM-master-0 k3s-$CL_NAM-master-0:/Users/Ubuntu

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "launch worker"`"
for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
	multipass launch ubuntu -n k3s-$CL_NAM-worker-$CNT -v -c $CPU_WORKERS -d $DRIVE_WORKERS -m $RAM_WORKERS
done

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "info"`"
multipass info k3s-$CL_NAM-master-0

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "install k3s on master"`"
# Get the IP of the master node
export K3S_NODEIP_MASTER="https://$(multipass info k3s-$CL_NAM-master-0 | grep "IPv4" | awk -F' ' '{print $2}'):6443"
echo K3S_NODEIP_MASTER $K3S_NODEIP_MASTER
# Deploy k3s on the master node
multipass exec k3s-$CL_NAM-master-0 -- /bin/bash -c "curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644"
# Get the TOKEN from the master node
K3S_TOKEN="$(multipass exec k3s-$CL_NAM-master-0 -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")"

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "upgrade workers"`"
for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
	multipass exec k3s-$CL_NAM-worker-$CNT sudo apt-get update
	multipass exec k3s-$CL_NAM-worker-$CNT -- /bin/bash -c "sudo apt-get upgrade --assume-yes"
	printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "k3s-$CL_NAM-worker-$CNT upgraded"`"
done

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "mount workers"`"
for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
	mkdir -p store/k3s-$CL_NAM-worker-$CNT
	multipass mount -v -u 502:1000 -g 20:1000 store/k3s-$CL_NAM-worker-$CNT k3s-$CL_NAM-worker-$CNT:/Users/Ubuntu
	printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "worker $CNT mounted"`"
done

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "multipass info workers"`"
for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
  INFO "k3s-$CL_NAM-worker-$CNT"
	multipass info k3s-$CL_NAM-worker-$CNT
	printf "%s\n" `RepeatColorStr ${Green} '*' 90`
done

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "deploy k3s on workers"`"
for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
	# Deploy k3s on the worker node
	multipass exec k3s-$CL_NAM-worker-$CNT -- /bin/bash -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -"
	INFO "k3s deployed on worker $CNT"
	printf "%s\n" `RepeatColorStr ${Green} '*' 90`
done

sleep 10
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "label worker-nodes"`"
multipass exec k3s-${CL_NAM}-master-0 -- /bin/bash -c "export KUBECONFIG=~/.kube/config:/etc/rancher/k3s/k3s.yaml"

for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
	multipass exec k3s-${CL_NAM}-master-0 -- /bin/bash -c "sudo kubectl label node k3s-${CL_NAM}-worker-${CNT} node-role.kubernetes.io/worker=worker"
done

# Configure taint NoSchedule for the k3s-master node
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "taint-nodes"`"
multipass exec k3s-$CL_NAM-master-0 -- /bin/bash -c "kubectl --kubeconfig=${HOME}/.kube/k3s.yaml taint node k3s-${CL_NAM}-master-0 node-role.kubernetes.io/master=effect:NoSchedule"

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "multipass list:"`"
multipass -v list
printf "%s\n" `RepeatColorStr ${Green} '*' 90`

sleep 10

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "kubectl get nodes"`"
multipass exec k3s-$CL_NAM-master-0 -- /bin/bash -c "sudo kubectl get nodes"
multipass exec k3s-$CL_NAM-master-0 -- /bin/bash -c "sudo kubectl get pods --all-namespaces"
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "cluster $CL_NAM completed"`"