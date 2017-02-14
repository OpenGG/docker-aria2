#!/bin/sh
set -e

_term() {
  echo "Caught SIGTERM signal, exiting pid ${pid}"
  kill -TERM "$pid" 2>/dev/null
  echo "[DONE]"
}

UID=${PUID:-1024}
GID=${PGID:-1024}

echo
echo "UID: ${UID}"
echo "GID: ${GID}"
echo

echo "Setting conf"

touch /config/aria2.session
touch /config/aria2.log
touch /config/aria2.err

if [[ ! -e /config/aria2.conf ]]
then
  cp /aria2.conf.default /config/aria2.conf
fi

echo "[DONE]"

echo "Setting owner and permissions"

chown -R ${UID}:${GID} /config
find /config -type d -exec chmod 755 {} +
find /config -type f -exec chmod 644 {} +

echo "[DONE]"

trap _term SIGTERM

echo "Starting aria2c";

su-exec ${UID}:${GID} \
    aria2c \
        --enable-rpc \
        --conf-path=/config/aria2.conf \
        --rpc-listen-port=6800 \
     > /config/aria2.log \
    2> /config/aria2.err &

pid=$!

echo "aria2c started with pid ${pid}"

wait "$pid"
