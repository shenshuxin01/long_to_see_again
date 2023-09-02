# 部署istio到k8s平台
1. 查看对应版本支持
https://istio.io/latest/zh/docs/releases/supported-releases/

2. 部署教程
https://istio.io/latest/zh/docs/setup/getting-started/

3. 我的k8s版本是v1.23.17，所以istio部署的是1.17	

## 部署步骤
1. 下载
https://github.com/istio/istio/releases =》 istio-1.17.5-linux-amd64.tar.gz
然后解压

2. 安装
istioctl install --set profile=demo -y

3. 给命名空间添加标签，指示 Istio 在部署应用的时候，自动注入 Envoy 边车代理：
kubectl label namespace ssx istio-injection=enabled

查看ns
kubectl get namespace -L istio-injection
kubectl label namespace ssx istio-injection=disabled
kubectl label namespace ssx istio-injection=disabled --overwrite

备份：
[root@node101 ~]# kubectl get pod
NAME                                 READY   STATUS    RESTARTS      AGE
netchecker-agent-hostnet-98p4x       1/1     Running   1 (17d ago)   17d
netchecker-agent-zgwxn               1/1     Running   1 (17d ago)   17d
netchecker-server-645d759b79-8tml8   2/2     Running   4 (15d ago)   17d

3. 部署示例bookinfo
cd istio家目录
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

kubectl get services

4. 确认服务启动成功
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

5. 开启外网访问
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

kubectl get svc istio-ingressgateway -n istio-system

没有配置LoadBalanceLoader支持，所以改成NodePort方式

apiVersion: v1
kind: Service
metadata:
  name: my-service-istio
spec:
  type: NodePort
  selector:
    app: productpage
  ports:
    - port: 9080
      targetPort: 9080
      nodePort: 30007

验证
curl http://node101:30007/productpage


6. 添加可视化工具kiali
kubectl apply -f samples/addons
kubectl rollout status deployment/kiali -n istio-system

istioctl dashboard kiali --address 192.168.0.101 --port 9988

验证
curl http://node101:9988


7. 清理bookinfo
samples/bookinfo/platform/kube/cleanup.sh

#### 测试container
kubectl run mytool2 --image=docker.io/curlimages/curl sleep 100000


# istio gateway使用demo
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ngdemo-gateway
  namespace: ssx
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "tomcat.shenshuxin.cn"
EOF


kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ngdemo-virtualservice
  namespace: ssx
spec:
  hosts:
  - "tomcat.shenshuxin.cn"
  gateways:
  - ngdemo-gateway
  http:
  - match:
    - uri:
        prefix: /v1
    route:
    - destination:
        port:
          number: 8082
        host: demo-tomcat-for-ingress-name
  - route:
    - destination:
        port:
          number: 8081
        host: demo-tomcat-for-ingress-name
EOF

curl -HHost:tomcat.shenshuxin.cn "http://node101:32318"
端口号是ingressgateway服务的nodeport



# istio部署测试服务之间的调用通信
## 部署两个tomcat服务pod并且配置serivce服务
注意部署的两个deployment需要指定一下版本标签`version: ??`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-tomcat-for-istio-name1
  namespace: ssx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo-tomcat-for-istio-dm
  template:
    metadata:
      labels:
        app: demo-tomcat-for-istio-dm
        version: vv11
    spec:
      containers:
          - image: 'docker.io/library/tomcat:8'
            imagePullPolicy: IfNotPresent
            name: demo-tomcat-c
            ports:
              - containerPort: 8080

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-tomcat-for-istio-name2
  namespace: ssx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo-tomcat-for-istio-dm
  template:
    metadata:
      labels:
        app: demo-tomcat-for-istio-dm
        version: vv22
    spec:
      containers:
          - image: 'docker.io/library/tomcat:8'
            imagePullPolicy: IfNotPresent
            name: demo-tomcat-c
            ports:
              - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: demo-tomcat-for-istio-sv-lb
  name: demo-tomcat-for-istio-name
  namespace: ssx
spec:
  ports:
    - name: tomcat8080
      port: 8081
      protocol: TCP
      targetPort: 8080
  selector:
    app: demo-tomcat-for-istio-dm
  type: ClusterIP

```

## 通过istio的虚拟服务进行流量管理
注意这里的hosts名称(demo-tomcat-for-istio-name)要和上面的service配置的一致，这样istio才可以进行流量管理。
这里设置了请求转发策略，并且设置自定义响应头
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: demo-tomcat-istio-vs
  namespace: ssx
spec:
  hosts:
    - demo-tomcat-for-istio-name
  http:
    - headers:
        request:
          set:
            test: "true"
      route:
        - destination:
            host: demo-tomcat-for-istio-name
            subset: vv11
          weight: 10
          headers:
            response:
              set:
                ssxppp: abc
        - destination:
            host: demo-tomcat-for-istio-name
            subset: vv22
          headers:
            response:
              set:
                ssxppp: 123
          weight: 90

---

apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: demo-tomcat-istio-dr
  namespace: ssx
spec:
  host: demo-tomcat-for-istio-name
  subsets:
    - name: vv11
      labels:
        version: vv11
    - name: vv22
      labels:
        version: vv22
```
## 验证
随便找一个集群中的通过istio代理的服务，执行curl命令：
```bash
# curl -I demo-tomcat-for-istio-name.ssx:8081
HTTP/1.1 200 OK
accept-ranges: bytes
etag: W/"8-1691939281480"
last-modified: Sun, 13 Aug 2023 15:08:01 GMT
content-type: text/html
content-length: 8
date: Tue, 15 Aug 2023 00:54:15 GMT
x-envoy-upstream-service-time: 2
server: envoy
ssxppp: fs
```
调用的方式是service名称.命名空间名称:端口号。
`curl -I`命令是只显示响应头



# istio手动注入sidecar
kubectl apply -f <(/root/apps/istio1.17/istio-1.17.5/bin/istioctl kube-inject -f xxx.yaml)

# istio整合springcloud+grpc
git clone -b dev-istio git@github.com:shenshuxin01/grpc-springboot.git

# istio外部授权
```sh
# 定义外部授权者
# kubectl edit configmap istio -n istio-system 
data:
  mesh: |-
    # 添加以下内容以定义外部授权者。
    extensionProviders:
    - name: "sample-ext-authz-http"
      envoyExtAuthzHttp:
        service: "ssx-java-web-sv.ssx.svc.cluster.local"
        port: "9001"
        includeRequestHeadersInCheck: ["Authorization","whoFlag","Cookie"]

curl -I -H "Authorization: aaa" -H "whoFlag: aaa" "http://ssx-java-web-sv.ssx.svc.cluster.local:9001/sssssss" 

# 启用外部授权
kubectl apply -n ssx -f - <<EOF
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: ext-authz-demo
  namespace: ssx
spec:
  selector:
    matchLabels:
      app: demo-istio-spring-dm
  action: CUSTOM
  provider:
    # 提供程序名称必须与 MeshConfig 中定义的扩展提供程序匹配。
    name: sample-ext-authz-http
  rules:
  # 规则指定何时触发外部授权器。
  - to:
    - operation:
        paths: ["/test1"]
EOF
```

## 验证istio外部授权
```sh
#未开启授权 curl -I "http://web-base.ssx:8083/test1?name=fffppp"
HTTP/1.1 200 OK
content-type: text/plain;charset=UTF-8
content-length: 14
date: Fri, 18 Aug 2023 05:37:46 GMT
x-envoy-upstream-service-time: 27
server: envoy
ssxppp: ffffffyyyyyyy-internall

#开启授权; 错误的jwt
#curl -I -H "Authorization: aaa" -H "whoFlag: aaa" "http://web-base.ssx:8083/test1?name=fffppp"
HTTP/1.1 401 Unauthorized
cache-control: no-cache, no-store, max-age=0, must-revalidate
pragma: no-cache
expires: 0
x-content-type-options: nosniff
x-frame-options: DENY
x-xss-protection: 1 ; mode=block
referrer-policy: no-referrer
x-envoy-upstream-service-time: 7
date: Fri, 18 Aug 2023 07:42:05 GMT
server: envoy
ssxppp: ffffffyyyyyyy-internall
transfer-encoding: chunked

#开启授权; 正确的jwt
#curl -I -H "Authorization: 正确的jwt" -H "whoFlag: aaa" "http://web-base.ssx:8083/test1?name=fffppp"
HTTP/1.1 200 OK
content-type: text/plain;charset=UTF-8
content-length: 14
date: Fri, 18 Aug 2023 07:42:41 GMT
x-envoy-upstream-service-time: 161
server: envoy
ssxppp: ffffffyyyyyyy-internall


```