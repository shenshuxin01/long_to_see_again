# docker清理镜像配合grep
## 删除镜像
docker rmi `docker images | grep node102:5000/ssx-java- | awk '{print $3}'`

## 删除容器
docker rm `docker ps -qa`

# docker运行docker本地私有仓库服务
`docker run -v /home/ssx/appdata/kubernetes-volume/registry:/var/lib/registry -p 5000:5000 --restart=always --name=docker-registry -d registry`

