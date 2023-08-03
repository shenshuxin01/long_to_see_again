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
kubectl label namespace default istio-injection=enabled

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

istioctl dashboard kiali --address node101 --port 9988

验证
curl http://node101:9988






