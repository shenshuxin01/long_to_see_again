containerd也是一个容器运行环境，和docker一样，区别是docker可以配置映射外网访问，docker可以制作dockerFile生成容器，但是containerd效率好些。

containerd不能直接运行镜像，需要先创建容器

# 命令
1. 查看镜像并指定空间
ctr -n k8s.io images ls

