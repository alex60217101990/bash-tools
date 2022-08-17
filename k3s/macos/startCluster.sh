#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../colors.sh
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../logger.sh -c=true

clear
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "start nodes of cluster $1"`"
multipass list
printf "%s\n" `RepeatColorStr ${Green} '*' 90`

((CNT=0))
while [ "" != "$(multipass list|grep k3s-$1-worker-$CNT|grep Stopped)" ]
do
  printf "%s\n" `RepeatColorStr ${Green} '*' 90`
	INFO "k3s-$1-worker-$CNT"
	if  multipass -v start k3s-$1-worker-$CNT; then
	    INFO "started ok"
		else
		  INFO "started ok" "started with warning"
	fi
	CNT=$(($CNT+1))
done

((CNT=0))
while [ "" != "$(multipass list|grep k3s-$1-master-$CNT|grep Stopped)" ]
do
  printf "%s\n" `RepeatColorStr ${Green} '*' 90`
	INFO "k3s-$1-master-$CNT"
	if  multipass -v start k3s-$1-master-$CNT; then
		  INFO "started ok"
		else
			INFO "started with warning"
	fi
	CNT=$(($CNT+1))
done

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "multipass list:"`"
multipass -v list
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "completed"`"