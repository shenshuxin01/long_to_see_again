1. 集群信息
- node101 64G 24C 1T （master+worker+etcd）
- node109 64G 56C 400G （master+worker+etcd）
- node102 24G 4C 100G （etcd）

2. 重置所有服务器
```sh
kubeadm reset -f
modprobe -r ipip
lsmod
rm -rf ~/.kube/
rm -rf /etc/kubernetes/
rm -rf /etc/systemd/system/kubelet.service.d
rm -rf /etc/systemd/system/kubelet.service
rm -rf /usr/bin/kube*
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /var/lib/etcd
rm -rf /var/etcd
kubectl delete serviceaccount kuboard-admin -n kuboard
kubectl delete serviceaccount kuboard-viewer -n kuboard
kubectl delete clusterrolebinding kuboard-admin-crb
kubectl delete clusterrolebinding kuboard-viewer-crb
kubectl delete namespace kuboard
```
3. 使用kuboard安装kubernetes
https://kuboard.cn/install/install-k8s.html
选择网络组件flannel

4. 部署nginx-ingress
https://github.com/kubernetes/ingress-nginx/blob/controller-v1.9.5/deploy/static/provider/cloud/deploy.yaml
```sh
#下载后编辑文件，参考本文档同级的文件（修改为国内镜像 修改为nodePort）
kubectl apply -f ./ingress-nginx.yml
#验证是否成功：
kubectl get svc -n ingress-nginx
#[root@node101 ~]# kubectl get svc -n ingress-nginx
#NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
#ingress-nginx-controller             NodePort    10.233.68.0      <none>        80:30553/TCP,443:30360/TCP   9m23s
#测试 
curl https://node101:30444
```

5. 部署istio
https://istio.io/latest/zh/docs/setup/install/istioctl/
下载压缩包 https://github.com/istio/istio/releases =》 istio-1.17.5-linux-amd64.tar.gz
安装：istioctl install
然后  kubectl edit service -n istio-system istio-ingressgateway
- 修改istio-ingressgateway的service为NodePort方式访问
- 修改istio的service类型externalTrafficPolicy为Local。为了获取客户真实ip

6. 配置shenshuxin.cn域名的https密钥给 ingess+istio
```sh
# k8s生成secret ingess
kubectl create -n ssx secret tls tls-sub-shenshuxin-cn-secert \
  --key=./key.pem \
  --cert=./cert.pem

kubectl create -n ingress-nginx secret tls tls-sub-shenshuxin-cn-secert \
  --key=./key.pem \
  --cert=./cert.pem
  
kubectl create -n istio-system secret tls acme-sub-name-shenshuxin.cn --key=./key.pem --cert=./cert.pem

# k8s生成secret istio
kubectl create -n ssx secret tls ssx-istio-grpc-springboot-secret \
  --key=./key.pem \
  --cert=./cert.pem
```

7. 安装kubernetes-dashboard
```sh
#同级文件 
kubectl apply -f ./dashboard.yml
#生成证书
kubectl -n kubernetes-dashboard create secret tls k8sdashboard-ssx --key ./key.pem --cert ./cert.pem
#生成永久的token
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: admin-user-robot-secret
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
type: kubernetes.io/service-account-token
EOF
#获取永久token
kubectl describe -n kubernetes-dashboard secrets/admin-user-robot-secret
#生成临时token一小时
kubectl -n kubernetes-dashboard create token admin-user
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
#打开 k8s.shenshuxin.cn网站
curl https://k8s.shenshuxin.cn:30444/
```
