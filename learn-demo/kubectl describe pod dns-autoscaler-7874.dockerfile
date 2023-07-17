kubectl describe pod dns-autoscaler-7874cf6bcf-z9z2j -n kube-system
kubectl logs -n kube-system dns-autoscaler-7874cf6bcf-z9z2j

[root@node101 ~]# kubectl get pods -o wide -n kube-system
NAME                                       READY   STATUS    RESTARTS        AGE    IP              NODE      NOMINATED NODE   READINESS GATES
calico-kube-controllers-74df5cd99c-v86zh   0/1     Running   69 (30m ago)    390d   192.168.0.101   node101   <none>           <none>
calico-node-gb2pv                          1/1     Running   41 (30m ago)    390d   192.168.0.101   node101   <none>           <none>
coredns-76b4fb4578-nm56s                   1/1     Running   40 (29m ago)    390d   10.234.104.24   node101   <none>           <none>
dns-autoscaler-7874cf6bcf-z9z2j            1/1     Running   181 (38s ago)   390d   10.234.104.19   node101   <none>           <none>
kube-apiserver-node101                     1/1     Running   219 (37s ago)   390d   192.168.0.101   node101   <none>           <none>
kube-controller-manager-node101            0/1     Running   287 (38s ago)   390d   192.168.0.101   node101   <none>           <none>
kube-proxy-46rrm                           1/1     Running   184 (38s ago)   390d   192.168.0.101   node101   <none>           <none>
kube-scheduler-node101                     1/1     Running   155 (27s ago)   390d   192.168.0.101   node101   <none>           <none>
metrics-server-749474f899-cvznj            0/1     Running   181 (77s ago)   390d   10.234.105.88   node101   <none>           <none>
nodelocaldns-74wzg                         1/1     Running   42 (30m ago)    390d   192.168.0.101   node101   <none>           <none>


发现pod的ip地址的物理机的ip，不对
systemctl status kubelet.service 查看配置


kubelet日志查看
journalctl -xefu kubelet

看系统日志

cat /var/log/messages


用kubectl 查看日志
# 注意：使用Kubelet describe 查看日志，一定要带上 命名空间，否则会报如下错误[root@node2 ~]# kubectl describe pod coredns-6c65fc5cbb-8ntpvError from server (NotFound): pods "coredns-6c65fc5cbb-8ntpv" not found

kubectl describe pod kubernetes-dashboard-849cd79b75-s2snt --namespace kube-system

kubectl logs -f pods/monitoring-influxdb-fc8f8d5cd-dbs7d -n kube-system

kubectl logs --tail 200 -f kube-apiserver -n kube-system |more

kubectl logs --tail 200 -f podname -n jenkins



用journalctl查看日志非常管用

journalctl -u kube-scheduler

journalctl -xefu kubelet

journalctl -u kube-apiserver


journalctl -u kubelet |tail

journalctl -xe


用docker查看日志

docker logs c36c56e4cfa3  (容器id)





Kubernetes各组件服务重启
MASTER端+NODE共同服务
systemctl restart etcd
systemctl daemon-reload
systemctl enable flanneld
systemctl restart flanneld

MASTER端独有服务
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl restart kube-apiserver

systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl restart kube-controller-manager

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl restart kube-scheduler

NODE端独有服务
systemctl daemon-reload
systemctl enable kubelet
systemctl restart kubelet（status状态为 not ready时候重启即可）

systemctl daemon-reload
systemctl enable kube-proxy
systemctl restart kube-proxy

 

systemctl status etcd
systemctl status flanneld
systemctl status kube-apiserver
systemctl status kube-controller-manager
systemctl status kube-scheduler
systemctl status kubelet
systemctl status kube-proxy







ExecStart=/usr/local/bin/kubelet \
                $KUBE_LOGTOSTDERR \
                $KUBE_LOG_LEVEL \
                $KUBELET_API_SERVER \
                $KUBELET_ADDRESS \
                $KUBELET_PORT \
                $KUBELET_HOSTNAME \
                $KUBELET_ARGS \
                $DOCKER_SOCKET \
                $KUBELET_NETWORK_PLUGIN \
                $KUBELET_VOLUME_PLUGIN \
                $KUBELET_CLOUDPROVIDER
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
[root@node101 system]# cat -/etc/kubernetes/kubelet.env
cat：无效选项 -- /
Try 'cat --help' for more information.
[root@node101 system]# cat /etc/kubernetes/kubelet.env
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=2"
KUBELET_ADDRESS="--node-ip=192.168.0.101"
KUBELET_HOSTNAME="--hostname-override=node101"



KUBELET_ARGS="--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf \
--config=/etc/kubernetes/kubelet-config.yaml \
--kubeconfig=/etc/kubernetes/kubelet.conf \
--pod-infra-container-image=k8s.gcr.io/pause:3.6 \
--runtime-cgroups=/systemd/system.slice \
  "
KUBELET_NETWORK_PLUGIN="--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
KUBELET_CLOUDPROVIDER=""






[root@node101 ~]# kubectl get deployment -n ssx
NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
ssx-elk-dm                                1/1     1            1           171d
ssx-ffmpeg-dm                             1/1     1            1           26d
ssx-java-developer-function-provider-dm   1/1     1            1           362d
ssx-java-web-dm                           1/1     1            1           369d
ssx-jenkins-dm                            0/0     0            0           390d
ssx-kafka-dm                              1/1     1            1           173d
ssx-mysql-dm                              1/1     1            1           390d
ssx-nginx-dm                              1/1     1            1           8d
ssx-redis-dm                              1/1     1            1           390d
ssx-sleuth-zipkin-dm                      1/1     1            1           172d


kubectl patch deployments.apps -n ssx ssx-elk-dm -p '{"spec":{"replicas":0}}'
kubectl patch deployments.apps -n ssx ssx-ffmpeg-dm -p '{"spec":{"replicas":0}}'
kubectl patch deployments.apps -n ssx ssx-java-developer-function-provider-dm -p '{"spec":{"replicas":0}}'
kubectl patch deployments.apps -n ssx ssx-java-web-dm -p '{"spec":{"replicas":0}}'
kubectl patch deployments.apps -n ssx ssx-kafka-dm -p '{"spec":{"replicas":0}}'
kubectl patch deployments.apps -n ssx ssx-nginx-dm -p '{"spec":{"replicas":0}}'
kubectl patch deployments.apps -n ssx ssx-redis-dm -p '{"spec":{"replicas":0}}'
kubectl patch deployments.apps -n ssx ssx-sleuth-zipkin-dm -p '{"spec":{"replicas":0}}'



kubectl delete pod -n ssx ssx-elk-dm-7c6bb6cfd6-8rgj8                                
kubectl delete pod -n ssx ssx-ffmpeg-dm-664548fcc4-q4cqh                            
kubectl delete pod -n ssx ssx-java-developer-function-provider-dm-764bb75b6c-mzx8b  
kubectl delete pod -n ssx ssx-java-web-dm-6f9d4b6ccc-7c92g                          
kubectl delete pod -n ssx ssx-kafka-dm-687b5dd99f-swn8l                             
kubectl delete pod -n ssx ssx-mysql-dm-866796c44f-fd68j                             
kubectl delete pod -n ssx ssx-nginx-dm-868f877d57-j6h7b                             
kubectl delete pod -n ssx ssx-redis-dm-5595c59d57-zql2b                             
kubectl delete pod -n ssx ssx-sleuth-zipkin-dm-5987dfc664-9l7kq          


待部署的环境：
1. elk
2. ffmpeg
3. kafka+zk 
4. zipkin 
5. node101安装buildkit
6. 修改ssx项目的jenkins.groovy文件镜像构建方式
7. 配置node101防火墙、防黑客侵入措施
