使用的是 kuboard 软件安装部署kubernetes

# k8s回滚应用
1. 创建/修改应用统一使用`apply`命令而非`create`
2. 使用`kubectl apply -f ./xxxdelpoyment.yaml --record=true`
3. 查询历史版本`kubectl rollout history  xxxdelpementnaem`
4. 注意一定要真正的修改了配置才会生效，比如更新了jar版本，相应的docker镜像版本需要更新

参考链接
[https://www.csdn.net/tags/OtDacgysMzAxMzktYmxvZwO0O0OO0O0O.html](https://www.csdn.net/tags/OtDacgysMzAxMzktYmx