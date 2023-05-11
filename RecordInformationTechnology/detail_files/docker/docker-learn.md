# docker清理镜像配合grep
## 删除镜像
docker rmi `docker images | grep node102:5000/ssx-java- | awk '{print $3}'`

## 删除容器
docker rm `docker ps -qa`

# docker运行docker本地私有仓库服务
`docker run -v /home/ssx/appdata/kubernetes-volume/registry:/var/lib/registry -p 5000:5000 --restart=always --name=docker-registry -d registry`

# 镜像导出 导入
```sh
#导出一个已经创建的容器导到一个文件
docker save -o 文件名.tar 容器id
#将文件导入为镜像
docker load 文件名.tar 镜像名:镜像标签
```