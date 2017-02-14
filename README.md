# docker-aria2

## Usage

0. `mkdir` a config dir, say `/storage/aria2`

0. Put `aria2.conf` file in the config dir, with following content.
[Config reference](https://aria2.github.io/manual/en/html/aria2c.html#aria2-conf)

    ```
    save-session=/config/aria2.session
    input-file=/config/aria2.session
    save-session-interval=60

    file-allocation=prealloc
    disk-cache=128M

    enable-rpc=true
    rpc-allow-origin-all=true
    rpc-listen-all=true
    rpc-secret=<password>

    auto-file-renaming=false
    ```
0. Run following command to start aria2 instance

    ```
    docker run \
      -d \
      --name aria2 \
      -e PGID=<gid> \
      -e PUID=<uid> \
      -v <path to config>:/config \
      -v <path to downloads>:/downloads \
      -p 6800:6800 \
      opengg/aria2
    ```

Note:
Make sure the download folder is writable by the given uid/gid.

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
`http://192.168.x.x:8080` would show you what's running INSIDE the container on port 80.


* `-p 6800` - the port(s)
* `-v /config` - where aria2 should store config files and logs
* `-v /downloads` - local path for downloads
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on alpine linux, for shell access whilst the container is running do `docker exec -it aria2 /bin/sh`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```
