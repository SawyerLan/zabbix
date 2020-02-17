#!/bin/bash

exe_path=$1
port=$2
password=$3
redis_info="/tmp/redis-info-${port}"
redis_info_res="/tmp/redis-info-res-${port}"
zabbix_sender=/usr/bin/zabbix_sender
zabbix_conf=/etc/zabbix/zabbix_agentd.conf

[ -z "$password" ] && other='' || other="-a $password"

$exe_path -h 127.0.0.1 -p $port  $other ping >/dev/null 2>&1
[ $? -eq 0 ] && is_running=1 || is_running=0

if [ "$is_running" -eq 1 ];then
$exe_path -h 127.0.0.1 -p $port  $other info 2>/dev/null 1> $redis_info
# redis-cli -a hydeesoft config get maxclients  2>/dev/null |tail -n +2
redis_max_conn=`$exe_path -h 127.0.0.1 -p $port  $other config get maxclients 2>/dev/null |tail -n +2`
info(){
    f=$1
    res=`cat $redis_info |grep -P "$f:" |awk -F':' '{print $2}' |sed  's/%//'`
    [ -z "$res" ] && echo '-99' || echo $res
}

cat > $redis_info_res<<EOF
- redis[$port,is_running] $is_running
- redis[$port,redis_max_conn] $redis_max_conn
- redis[$port,uptime_in_seconds] $(info uptime_in_seconds)
- redis[$port,connected_clients] $(info connected_clients)
- redis[$port,client_recent_max_input_buffer] $(info client_recent_max_input_buffer)
- redis[$port,cient_recent_max_output_buffer] $(info client_recent_max_output_buffer)
- redis[$port,blocked_clients] $(info blocked_clients)
- redis[$port,used_memory] $(info used_memory)
- redis[$port,used_memory_rss] $(info used_memory_rss)
- redis[$port,used_memory_peak] $(info used_memory_peak)
- redis[$port,used_memory_peak_perc] $(info used_memory_peak_perc)
- redis[$port,maxmemory] $(info maxmemory)
- redis[$port,total_system_memory] $(info total_system_memory)
- redis[$port,mem_fragmentation_ratio] $(info mem_fragmentation_ratio)
- redis[$port,loading] $(info loading)
- redis[$port,rdb_changes_since_last_save] $(info rdb_changes_since_last_save)
- redis[$port,rdb_bgsave_in_progress] $(info rdb_bgsave_in_progress)
- redis[$port,rdb_last_save_time] $(info rdb_last_save_time)
- redis[$port,rdb_last_bgsave_status] $(info rdb_last_bgsave_status)
- redis[$port,rdb_last_bgsave_time_sec] $(info rdb_last_bgsave_time_sec)
- redis[$port,rdb_current_bgsave_time_sec] $(info rdb_current_bgsave_time_sec)
- redis[$port,rdb_last_cow_size] $(info rdb_last_cow_size)
- redis[$port,aof_enabled] $(info aof_enabled)
- redis[$port,total_connections_received] $(info total_connections_received)
- redis[$port,total_commands_processed] $(info total_commands_processed)
- redis[$port,instantaneous_ops_per_sec] $(info instantaneous_ops_per_sec)
- redis[$port,total_net_input_bytes] $(info total_net_input_bytes)
- redis[$port,total_net_output_bytes] $(info total_net_output_bytes)
- redis[$port,rejected_connections] $(info rejected_connections)
- redis[$port,sync_full] $(info sync_full)
- redis[$port,sync_partial_ok] $(info sync_partial_ok)
- redis[$port,sync_partial_err] $(info sync_partial_err)
- redis[$port,expired_keys] $(info expired_keys)
- redis[$port,role] $(info role)
- redis[$port,master_host] $(info master_host)
- redis[$port,master_port] $(info master_port)
- redis[$port,master_link_status] $(info master_link_status)
EOF
else
cat > $redis_info_res<<EOF
- redis[$port,is_running] $is_running
EOF
fi

$zabbix_sender -vv -c $zabbix_conf  -i $redis_info_res >/tmp/zabbix_sender_redis.log 2>&1
exit_code=$?
echo $exit_code