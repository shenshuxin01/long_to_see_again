# 通过k8s部署elk8.10.2版本
## 创建配置文件
```sh
[root@node101 config]# pwd
/home/app/apps/k8s/for_docker_volume/elk/kibana8/config
[root@node101 config]# cat node.options 
## Node command line options
## See `node --help` and `node --v8-options` for available options
## Please note you should specify one option per line

## max size of old space in megabytes
#--max-old-space-size=4096

## do not terminate process on unhandled promise rejection
 --unhandled-rejections=warn

## restore < Node 16 default DNS lookup behavior
--dns-result-order=ipv4first

## enable OpenSSL 3 legacy provider
#--openssl-legacy-provider
[root@node101 config]# cat kibana.yml 
#
# ** THIS IS AN AUTO-GENERATED FILE **
#

# Default Kibana configuration for docker target
server.host: "0.0.0.0"
server.shutdownTimeout: "5s"
elasticsearch.hosts: [ "http://localhost:9200" ]
monitoring.ui.container.elasticsearch.enabled: true
i18n.locale: "zh-CN"
```