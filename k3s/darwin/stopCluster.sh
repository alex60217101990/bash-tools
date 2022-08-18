#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../colors.sh
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../../logger.sh -c=true

clear
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "stop nodes of cluster $1"`"
multipass list
printf "%s\n" `RepeatColorStr ${Green} '*' 90`

((CNT=0))
while [ "" != "$(multipass list|grep k3s-$1-worker-$CNT|grep Running)" ]
do
  printf "%s\n" `RepeatColorStr ${Green} '*' 90`
	INFO "k3s-$1-worker-$CNT"
	if multipass -v stop k3s-$1-worker-$CNT; then
		  	INFO "stopped ok"
		else
		  INFO "stopped with warning"
	fi
	CNT=$(($CNT+1))
done

((CNT=0))
while [ "" != "$(multipass list|grep k3s-$1-master-$CNT|grep Running)" ]
do
	printf "%s\n" `RepeatColorStr ${Green} '*' 90`
	INFO "k3s-$1-master-$CNT"
	if  multipass -v stop k3s-$1-master-$CNT; then
		  	INFO "stopped ok"
		else
			INFO "stopped with warning"
	fi
	CNT=$(($CNT+1))
done

printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "multipass list:"`"
multipass -v list
printf "%s %s\n" `RepeatColorStr ${Green} '*' 90` "`CyanStr "completed"`"