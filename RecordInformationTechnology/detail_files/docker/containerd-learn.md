containerd也是一个容器运行环境，和docker一样，区别是docker可以配置映射外网访问，docker可以制作dockerFile生成容器，但是containerd效率好些。

containerd不能直接运行镜像，需要先创建容器

# 命令
1. 查看镜像并指定空间
ctr -n k8s.io images ls


# 创建jdk21镜像
1. 下载java21解压版本
2. 跳转到压缩包路径并确保包名是jdk-21_linux-x64_bin.tar.gz，然后生成下面的Dockerfile
```yaml
FROM daocloud.io/centos:7
COPY ./jdk-21_linux-x64_bin.tar.gz /
ENV JAVA_HOME=/jdk-21
ENV PATH=$JAVA_HOME/bin:$PATH
ENV LC_ALL=zh_CN.utf8
ENV LANG=zh_CN.UTF8
ENV LANGUAGE=zh_CN.utf8
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && tar -zxf /jdk-21_linux-x64_bin.tar.gz -C /
CMD ["--version"]
ENTRYPOINT ["java"]
```
3. 使用buildkit创建镜像
```sh
buildctl build \
	--frontend=dockerfile.v0 \
	--local context=. \
	--local dockerfile=. \
	--output type=image,name=ssx.docker.io/jdk:21
```