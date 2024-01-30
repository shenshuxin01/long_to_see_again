1. unbuntu2204版本部署k8s的etcd服务后，主机不能解析DNS
    解决方法： 
    echo 'nameserver 8.8.8.8' >> /etc/resolv.conf