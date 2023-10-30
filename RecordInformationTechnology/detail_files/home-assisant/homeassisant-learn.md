# 官网教程
https://developers.home-assistant.io/docs/creating_component_index

https://github.com/home-assistant/example-custom-config

# 使用docker方式部署
https://www.home-assistant.io/installation/linux

## 启动命令
```sh
docker run -d \
  --name homeassistant \
  --privileged \
  -p 8123:8123 \
  --restart=unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /home/ssx/appdata/homeassisant/config:/config \
  -v /etc/localtime:/etc/localtime \
  --network=host \
  -v /home/ssx/appdata/homeassisant/media/cdrom:/media/cdrom \
  ghcr.io/home-assistant/home-assistant:stable
```
## 修改配置文件`configuration.yaml` 仅参考，不是最新版本，新版本查看https://github.com/shenshuxin01/home-assisant-ssx-example-custom-config
```yaml
# [ssx@archlinux config]$ cat /home/ssx/appdata/homeassisant/config/configuration.yaml 
# Loads default set of integrations. Do not remove.
default_config:

# Load frontend themes from the themes folder
frontend:
  themes: !include_dir_merge_named themes

#开启rest服务调用
api:

# Text to speech
tts:
  - platform: edge_tts
    service_name: xiaomo_say # service: tts.xiaomo_say
    language: zh-CN-XiaoxiaoNeural
    volume: +10%


automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml

#拼多多购买的cozylife灯泡和插座
hass_cozylife_local_pull:

#自定义ssx插件
example_load_platform:

# Example configuration.yaml entry
logger:
  default: error
  logs:
    custom_components.example_load_platform: info
    custom_components.hass_cozylife_local_pull: info
```

# 集成第三方平台插件：cozylife
因为我买了他家的一个控制灯泡，需要集成下
https://github.com/cozylife/hass_cozylife_local_pull/issues/6
## 自己复制了他的代码然后改动了一下，不需要外网就可以访问
git@github.com:shenshuxin01/hass_cozylife_local_pull.git

# 安装hacs
https://hacs.xyz/docs/setup/download

# 开发插件
https://github.com/shenshuxin01/home-assisant-ssx-example-custom-config/tree/master/custom_components/example_load_platform

# 开发HA服务service调用插件
例如 tts
- https://www.home-assistant.io/integrations/tts#post-apitts_get_url
- https://github.com/hasscc/hass-edge-tts
- https://www.home-assistant.io/integrations/sensor.rest
- https://developers.home-assistant.io/docs/api/rest

1. 需要在configuration.yaml配置新增
    - `api:`
2. 登录homeassistant页面设置里面新增token

## 调用示例
```yaml
service: switch.toggle
data: {}
target:
  entity_id: switch.example_load_platform_ssxswitchentity_attr_unique_id

service: tts.xiaomo_say
data:
  entity_id: media_player.ke_fang
  message: 能听到吗
  cache: true
```
## 获取所有的服务
<!-- -H "Authorization: Bearer <ACCESS TOKEN>" -->
```sh
curl \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI5OTE3Y2Y0MDE5MDM0MTQwOGE3ZDhhNDNhZmQ0ZDMyZSIsImlhdCI6MTY5NzI4MjU0NSwiZXhwIjoyMDEyNjQyNTQ1fQ.p-Tn2zcv1P_gHxJzATZpxm-vo83rmi9avQds7NgaR8k" \
  -H "Content-Type: application/json" \
  http://ssx-homeassistant-dmsv.ssx:9000/api/services
```

## 调用服务实例，例如改变switch的状态关开
```sh
curl \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI5OTE3Y2Y0MDE5MDM0MTQwOGE3ZDhhNDNhZmQ0ZDMyZSIsImlhdCI6MTY5NzI4MjU0NSwiZXhwIjoyMDEyNjQyNTQ1fQ.p-Tn2zcv1P_gHxJzATZpxm-vo83rmi9avQds7NgaR8k" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.example_load_platform_ssxswitchentity_attr_unique_id"}' \
  http://ssx-homeassistant-dmsv.ssx:9000/api/services/switch/toggle

```

## 调用服务实例，例如播放语音到homepodmini
```sh
curl \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI5OTE3Y2Y0MDE5MDM0MTQwOGE3ZDhhNDNhZmQ0ZDMyZSIsImlhdCI6MTY5NzI4MjU0NSwiZXhwIjoyMDEyNjQyNTQ1fQ.p-Tn2zcv1P_gHxJzATZpxm-vo83rmi9avQds7NgaR8k" \
  -H "Content-Type: application/json;charset=UTF-8" \
  -d '{"entity_id": "media_player.ke_fang","message": "能听到吗","cache": true}' \
  http://ssx-homeassistant-dmsv.ssx:9000/api/services/tts/xiaomo_say

```


scp -r custom_components/example_load_platform/ root@node101:/home/app/apps/k8s/for_docker_volume/homeassistant/config/custom_components
scp configuration.yaml root@node101:/home/app/apps/k8s/for_docker_volume/homeassistant/config/
scp secrets.yaml root@node101:/home/app/apps/k8s/for_docker_volume/homeassistant/config/

# 删除history记录表
sqlite> select * from states_meta where entity_id="sensor.node12cpumemsensor_sensor"; 
sqlite> DELETE FROM states WHERE metadata_id=43; 


# 使用k8s-ingress方式配置域名访问后端hass
- 域名： hass.shenshuxin.cn
- 修改ingress-nginx-controller的deployment文件：
  ```yaml
  kind: Deployment
  spec:
    template: 
      metadata: 
        annotations:
          "cni.projectcalico.org/ipAddrs": "[\"10.234.105.88\"]" #指定容器pod的地址，如果多个容器使用ipV4pools?参数
  ```
- 配置hass的config目录下的配置文件configuration.yaml
  ```yaml
  http:
    use_x_forwarded_for: true
    trusted_proxies:
      - 10.234.105.88
  ```
- 配置ingress-nginx-contoller的configMap
  ```yaml
  kind: ConfigMap
  data:
    allow-snippet-annotations: 'true'
  ```
- 新增ingress-hass
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/auth-url: 'https://oauth2.shenshuxin.cn:30443/checkAdmin'
    nginx.ingress.kubernetes.io/configuration-snippet: |
      sub_filter '<head>' '<head><script>window.externalApp={getExternalAuth:function(){window.externalAuthSetToken(true,{"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJkYjM3NWQ1Y2RlZTc0NzBlODc3YzA0ZGE0ZjJiNDdiMiIsImlhdCI6MTY5MDQ5NzU3OSwiZXhwIjoyMDA1ODU3NTc5fQ.xgll212fYbTYj1yEsQ2jtwpWh9Bz7lhOKBZSh3wG6Gs","expires_in":248832000});},revokeExternalAuth:function(){window.externalAuthRevokeToken(false);}};</script>';
      sub_filter_once on;
      location /auth/authorize {
        return 301 /?external_auth=1;
      }
  name: hass-ingress
  namespace: ssx
spec:
  ingressClassName: nginx
  rules:
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
  tls:
    - hosts:
        - hass.shenshuxin.cn
      secretName: tls-sub-shenshuxin-cn-secert
```










