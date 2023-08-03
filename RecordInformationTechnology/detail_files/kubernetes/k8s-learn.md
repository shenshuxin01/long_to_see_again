使用的是 kuboard 软件安装部署kubernetes

# k8s回滚应用
1. 创建/修改应用统一使用`apply`命令而非`create`
2. 使用`kubectl apply -f ./xxxdelpoyment.yaml --record=true`
3. 查询历史版本`kubectl rollout history  xxxdelpementnaem`
4. 注意一定要真正的修改了配置才会生效，比如更新了jar版本，相应的docker镜像版本需要更新

# 安装kuboard可视化管理工具
kubectl apply -f https://addons.kuboard.cn/kuboard/kuboard-v3-swr.yaml

# 部署ingress
## 部署ingress controller
https://blog.csdn.net/m0_57776598/article/details/123978634

## k8s和ingress-nginx版本
https://github.com/kubernetes/ingress-nginx

## k8s部署
https://github.com/kubernetes/ingress-nginx/blob/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
### 替换国外镜像
ctr -n k8s.io i pull registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller:v1.1.1
ctr -n k8s.io i pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-webhook-certgen:v1.1.1

## 部署ingress资源
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-demo-ssx1
  namespace: ssx
spec:
  ingressClassName: nginx
  rules:
    - host: shenshuxin.cn
      http:
        paths:
          - backend:
              service:
                name: ssx-elk-sv
                port:
                  number: 9011
            path: /
            pathType: Prefix
    - host: hass.shenshuxin.cn
      http:
        paths:
          - backend:
              service:
                name: ssx-homeassistant-dmsv
                port:
                  number: 9000
            path: /
            pathType: Prefix

```