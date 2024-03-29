使用的是 kuboard 软件安装部署kubernetes

# k8s回滚应用
1. 创建/修改应用统一使用`apply`命令而非`create`
2. 使用`kubectl apply -f ./xxxdelpoyment.yaml --record=true`
3. 查询历史版本`kubectl rollout history  xxxdelpementnaem`
4. 注意一定要真正的修改了配置才会生效，比如更新了jar版本，相应的docker镜像版本需要更新

# k8s部署pod报错
https://cloud.tencent.com/developer/article/1868092
```yaml
#  ctr -n k8s.io i pull registry.aliyuncs.com/k8sxio/pause:3.6 && ctr -n k8s.io i tag   registry.aliyuncs.com/k8sxio/pause:3.6 k8s.gcr.io/pause:3.6

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

# 安装kuboard可视化管理工具
kubectl apply -f https://addons.kuboard.cn/kuboard/kuboard-v3-swr.yaml

# 部署ingress
https://kubernetes.io/zh-cn/docs/concepts/services-networking/ingress-controllers/

## 部署ingress controller
https://blog.csdn.net/m0_57776598/article/details/123978634

## k8s和ingress-nginx版本
https://github.com/kubernetes/ingress-nginx

## k8s部署ingress-nginx
https://github.com/kubernetes/ingress-nginx/blob/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
### 替换国外镜像
ctr -n k8s.io i pull registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller:v1.1.1
ctr -n k8s.io i pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-webhook-certgen:v1.1.1

验证 
[root@node101 ~]# kubectl get service -n ingress-nginx 
NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.233.133.76    <none>        80:32031/TCP,443:31455/TCP   3h35m

## 部署ingress资源
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-demo-tomcat-for-ingress-name
  namespace: ssx
spec:
  ingressClassName: nginx
  rules:
    - host: tomcat.shenshuxin.cn
      http:
        paths:
          - backend:
              service:
                name: demo-tomcat-for-ingress-name
                port:
                  number: 8081
            path: /
            pathType: Prefix
```


## 使用k8s的service类型为ClusterIp部署ingress
Service类型是ClusterIP类型，ClusterIP类型的Service只能从K8S集群内部访问，因此需要将其与Ingress Controller结合使用，以便外部客户端可以访问集群中的应用程序。当客户端请求到达Ingress时，Ingress Controller会将请求路由到相应的Service，然后Service再将请求路由到Pod中运行的容器。

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: demo-tomcat-for-ingress-lb
  name: demo-tomcat-for-ingress-name
  namespace: ssx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo-tomcat-for-ingress-lb
  template:
    metadata:
      labels:
        app: demo-tomcat-for-ingress-lb
    spec:
      containers:
      - image: docker.io/library/tomcat:8
        name: demo-tomcat-c
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: demo-tomcat-for-ingress-svc-lb
  name: demo-tomcat-for-ingress-name
  namespace: ssx
spec:
  ports:
  - name: tomcat8080
    port: 8081
    targetPort: 8080
  selector:
    app: demo-tomcat-for-ingress-lb
  type: ClusterIP
```

部署后查看
[root@node101 ~]# kubectl get service -n ssx 
NAME                           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT
demo-tomcat-for-ingress-name   ClusterIP   10.233.33.75     <none>        8081/TCP 

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-tomcat-for-ingress-name
  namespace: ssx
spec:
  ingressClassName: nginx
  rules:
    - host: tomcat.shenshuxin.cn
      http:
        paths:
          - backend:
              service:
                name: demo-tomcat-for-ingress-name
                port:
                  number: 8081
            path: /
            pathType: Prefix
```

验证
curl http://tomcat.shenshuxin.cn:部署的ingress-nginx的service的NodePort（这里是32031）


# k8s生成secret
```sh
kubectl create -n ssx secret tls tls-sub-shenshuxin-cn-secert \
  --key=./key.pem \
  --cert=./cert.pem
```

# ingress配置外部授权auth进行鉴权,配置一个`auth-url`即可
参考 https://kubernetes.github.io/ingress-nginx/examples/auth/external-auth/

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-demo-tomcat-for-ingress-name
  namespace: ssx
  annotations:
    nginx.ingress.kubernetes.io/auth-url: https://oauth2.shenshuxin.cn:30443/checkAdmin
spec:
  ingressClassName: nginx
  rules:
    - host: shenshuxin.cn
      http:
        paths:
          - backend:
              service:
                name: demo-tomcat-for-ingress-name
                port:
                  number: 8081
            path: /
            pathType: Prefix
  tls:
    - hosts:
        - shenshuxin.cn
      secretName: acmen-for-k8s-secret

```

# ingress-nginx配置自定义错误页面
* https://kubernetes.github.io/ingress-nginx/user-guide/custom-errors/
* https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#custom-http-errors
```sh
# 配置ingress-nginx-controller的Deployment命令行启动新增参数，这个服务名字是我的oauth2服务8080端
containers.args = '--default-backend-service=ssx/ssx-istio-grpc-springboot-dmsv'
# 配置namespace: ingress-nginx的ConfigMap新增值
custom-http-errors: '403,401'
```

# etcd
```sh
export ETCDCTL_API=3

alias etcdctl='etcdctl --endpoints=https://192.168.0.101:2379,https://192.168.0.102:2379,https://192.168.0.109:2379 --cacert=/etc/ssl/etcd/ssl/ca.pem --cert=/etc/ssl/etcd/ssl/admin-node101.pem --key=/etc/ssl/etcd/ssl/admin-node101-key.pem'

etcdctl member list

etcdctl endpoint status --write-out=table

etcdctl endpoint health
```