## Bash tools:

### Custom bash output logging:

- From current directory with scripts source <span style="color: orange; font-style: italic;">logger.sh</span> file:
```shell
$ source ./logger.sh -c=true
```

colors for output can include/exclude with flag <span style="color: orange; font-style: italic;">-c</span>

after this you can write beauty logs in terminal:
```shell
$ INFO "test some text"
$ DEBUG "test some debug"
$ ERROR "test some error"
```

output example:
![output example](./Screenshot.png)

### k3s cluster utils:

##### Stop existing cluster: 
```shell
$ /bin/bash github.com/alex60217101990/bash-tools/k3s/library.sh -a stop -n local-env 
```

#### Deploy new cluster:
```shell
$ /bin/bash github.com/alex60217101990/bash-tools/k3s/library.sh -a apply -n local-env -sc 2 -rm 4G -rs 4G -mm 30G -ms 20G -cm 2 -cs 2
```

##### Start existing cluster:
```shell
$ /bin/bash github.com/alex60217101990/bash-tools/k3s/library.sh -a start -n local-env 
```

##### Delete existing cluster:
```shell
$ /bin/bash github.com/alex60217101990/bash-tools/k3s/library.sh -a delete -n local-env 
```