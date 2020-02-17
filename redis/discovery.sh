#!/bin/bash

name=$1
info="/tmp/discovery_${name}.log"
res="/tmp/discovery_${name}_res.log"
sudo netstat -tlnp4 |grep "$name" |awk '{print $4,$7}' |awk -F':' '{print $2}' > $info

>$res

while read line
do
    # 26379 13955/redis-sentine
    port=`echo $line |awk '{print $1}'`
    pid=`echo $line |awk '{print $2}' |awk -F'/' '{print $1}'`
    exe_path=`sudo readlink /proc/$pid/exe`
    redis_cli=`dirname $exe_path`/redis-cli
    echo $redis_cli $port >> $res
done < $info

/usr/bin/env python /etc/zabbix/scripts/parse_listen_program.py /tmp/discovery_${name}_res.log
