sudo docker run -d \
  --restart=unless-stopped \
  --name=kuboard \
  -p 80:80/tcp \
  -p 10081:10081/tcp \
  -e KUBOARD_ENDPOINT="http://192.168.234.129:80" \
  -e KUBOARD_AGENT_SERVER_TCP_PORT="10081" \
  -v /root/kuboard-data:/data \
  swr.cn-east-2.myhuaweicloud.com/kuboard/kuboard:v3
  # 也可以使用镜像 swr.cn-east-2.myhuaweicloud.com/kuboard/kuboard:v3 ，可以更快地完成镜像下载。
  # 请不要使用 127.0.0.1 或者 localhost 作为内网 IP \
  # Kuboard 不需要和 K8S 在同一个网段，Kuboard Agent 甚至可以通过代理访问 Kuboard Server \


docker run -d \
  --privileged \
  --restart=unless-stopped \
  --name=kuboard-spray \
  -p 80:80/tcp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/kuboard-spray-data:/data \
  swr.cn-east-2.myhuaweicloud.com/kuboard/kuboard-spray:latest-amd64
  # 如果抓不到这个镜像，可以尝试一下这个备用地址：
  # swr.cn-east-2.myhuaweicloud.com/kuboard/kuboard-spray:latest-amd64


[root@k8s-master ~]# kubeadm token create
m3fmc3.pgidt2ss4rnoindq
[root@k8s-master ~]# kubeadm token list

[root@k8s-master ~]# openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
d6f9689c4fd00c98d949d472fb4300240ed152732eb05675087b6e7316e6caa3

[root@k8s-master ~]# kubeadm init phase upload-certs --upload-certs  --v=999
7d8042f6d6d15df7cf66bdae842b4109e7e6509de7f1ac2c0f565c43db152d0e

kubeadm join node101:6443  --token i2fa9w.1t2slrwczlazvnks \
--discovery-token-ca-cert-hash sha256:d6f9689c4fd00c98d949d472fb4300240ed152732eb05675087b6e7316e6caa3 \
--certificate-key 7d8042f6d6d15df7cf66bdae842b4109e7e6509de7f1ac2c0f565c43db152d0e

rsync -a /etc/kubernetes/pki node109:/etc/kubernetes/




yum remove -y kubelet kubeadm kubectl

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