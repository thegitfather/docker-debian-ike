## Shrew Soft VPN Client Container with auto-reconnect and simple port forward

Based on Debian jessie.

### Install

- copy your ikec config file (`%HOME/.ike/sites`) to `sites` folder
- build image with `docker build -t debian-ike:0.1 .`

### Create and work with container

```shell
$ docker run -ti -p [port]:[port] --privileged --name ike debian-ike:0.1 [CONFIG] [USER] [PW] [TARGET] [PORT]
```

- `[port]:[port]` docker port forward container <-> host
- `CONFIG` is the filename in your sites folder
- `TARGET` is `ip:port` which will be used to setup a TCP4 port forward with `socat`
- last `PORT` specifies socat's port to open and map to target   

After first run you can:

```shell
$ docker start/stop/kill/attach ike
```