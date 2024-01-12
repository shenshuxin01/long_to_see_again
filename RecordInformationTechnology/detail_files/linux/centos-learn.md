1. yum常用命令
- 更新库 yum update
- 配置阿里镜像 
 - cd /etc/yum.repos.d
 - wget http://mirrors.aliyun.com/repo/Centos-7.repo
 - mv Centos-7.repo CentOS-Base.repo
 - yum clean all
 - yum makecache
 - yum update -y



