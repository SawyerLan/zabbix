## 概述
本文主要基于zabbix自动发现监控redis，redis指标主要通过 **redis-cli info** 命令采集，并使用zabbix-sender 将监控数据发送至zabbix-server。
## 环境描述
1. zabbix-server 4.0
2. zabbix-sender 4.0
3. python2.7
4. redis 5.0.5 
## 工作原理
zabbix discovery自动发现redis端口及redis-cli路径，request.redis 该key执行时会触发zabbix-sender发送数据给zabbix-server。
## 代码
[https://github.com/SawyerLan/zabbix](https://github.com/SawyerLan/zabbix)
## 文件解读
```
├── discovery.sh 
├── parse_listen_program.py
├── redis.sh
├── sudo_zabbix
├── userparameter_discovery.conf
├── userparameter_redis.conf
└── zbx_export_templates.xml
```
> discovery.sh 自动发现脚本，参数1个服务名
> parse_listen_program.py 解析自动发现结果为json格式
> redis.sh redis监控主脚本，参数1 redis-cli路径， 参数2 redis 端口，参数3 redis密码(无密码不用传)
> sudo_zabbix 配置zabbix的sudo权限
> userparameter_discovery.conf 自动发现配置文件
> userparameter_redis.conf redis监控配置文件
> zbx_export_templates.xml redis监控模板
## 配置步骤
1. 导入zbx_export_templates.xml 模板至zabbix
2. 配置zabbix的sudo权限，权限见sudo_zabbix
3. 复制脚本，将discovery.sh parse_listen_program.py redis.sh 复制到zabbix-agent的对应目录，
4. 配置zabbix-agent配置文件，将userparameter_discovery.conf和userparameter_redis.conf 放在你对应的目录下
5. 修改配置，修改userparameter_discovery.conf userparameter_redis.conf 文件中的脚本为你第3点配置的脚本路径
6. 重新启动zabbix-agent
7. 模板关联需要监控的主机
8. (可选)如果你的redis有密码，可以在redis模板或者主机定义REDIS_PWD 宏变量，模板已经配置该变量，可参考下图
![zabbix宏变量](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9zZWdtZW50ZmF1bHQuY29tL2ltZy9iVmJEdUliL3ZpZXc?x-oss-process=image/format,png)

## 效果图![redis监控](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9zZWdtZW50ZmF1bHQuY29tL2ltZy9iVmJEdUlrL3ZpZXc?x-oss-process=image/format,png)

## 触发器![zabbix 触发器](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9zZWdtZW50ZmF1bHQuY29tL2ltZy9iVmJEdUlVL3ZpZXc?x-oss-process=image/format,png)

#### 如有疑问可通过以下途径联系
![运维724](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9zZWdtZW50ZmF1bHQuY29tL2ltZy9iVmJBWWRUL3ZpZXc?x-oss-process=image/format,png)
QQ 群
![在这里插入图片描述](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9zZWdtZW50ZmF1bHQuY29tL2ltZy9iVmJEdUt4L3ZpZXc?x-oss-process=image/format,png)
