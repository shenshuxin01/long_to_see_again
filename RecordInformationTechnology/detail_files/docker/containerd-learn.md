containerd也是一个容器运行环境，和docker一样，区别是docker可以配置映射外网访问，docker可以制作dockerFile生成容器，但是containerd效率好些。

containerd不能直接运行镜像，需要先创建容器

# 命令
1. 查看镜像并指定空间
ctr -n k8s.io images ls


# 创建jdk21镜像
1. 下载java21解压版本,删除rz.zip等文件,解压命名目录为jdk-21
2. 生成下面的Dockerfile
```sh
cd /root/apps
cat > Dockerfile <<EOF
FROM daocloud.io/centos:7
COPY ./jdk-21 /jdk-21
ENV JAVA_HOME=/jdk-21
ENV PATH=\$JAVA_HOME/bin:\$PATH
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
CMD ["--version"]
ENTRYPOINT ["java"]
EOF
```
3. 使用buildkit创建镜像
```sh
buildctl build \
	--frontend=dockerfile.v0 \
	--local context=. \
	--local dockerfile=. \
	--output type=image,name=ssx.docker.io/jdk:21
```


# containerd配置
```sh
# cat /etc/containerd/config.toml
version = 2
root = "/var/lib/containerd"
state = "/run/containerd"
oom_score = 0

[grpc]
  max_recv_message_size = 16777216
  max_send_message_size = 16777216

[debug]
  level = "info"

[metrics]
  address = ""
  grpc_histogram = false

[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    sandbox_image = "registry.aliyuncs.com/k8sxio/pause:3.6"
    max_container_log_line_size = -1
    [plugins."io.containerd.grpc.v1.cri".containerd]
      default_runtime_name = "runc"
      snapshotter = "overlayfs"
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          runtime_engine = ""
          runtime_root = ""
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            systemdCgroup = true
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://bqr1dr1n.mirror.aliyuncs.com"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
          endpoint = ["https://registry.aliyuncs.com/k8sxio"]
```