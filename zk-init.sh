#!/bin/bash

set -e

# Generate the config only if it doesn't exist
if [[ ! -f "/opt/zookeeper/conf/zoo.cfg" ]]; then
    CONFIG="/opt/zookeeper/conf/zoo.cfg"

    echo "clientPort=$ZOO_CLIENT_PORT" >> "$CONFIG"
    echo "dataDir=/var/zookeeper" >> "$CONFIG"
    echo "dataLogDir=/var/log/zookeeper" >> "$CONFIG"

    echo "tickTime=2000" >> "$CONFIG"
    echo "initLimit=10" >> "$CONFIG"
    echo "syncLimit=5" >> "$CONFIG"

    echo "autopurge.snapRetainCount=3" >> "$CONFIG"
    echo "autopurge.purgeInterval=1" >> "$CONFIG"
    echo "maxClientCnxns=60" >> "$CONFIG"

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done
fi

# Write myid only if it doesn't exist
if [[ ! -f "/var/zookeeper/myid" ]]; then
    echo "${ZOO_MY_ID:-1}" > "/var/zookeeper/myid"
fi

exec "$@"