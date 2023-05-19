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
  -v /home/ssx/appdata/homeassisant/media/cdrom:/media/cdrom \
  ghcr.io/home-assistant/home-assistant:stable
```
## 修改配置文件`configuration.yaml`
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
```
## 获取所有的服务
<!-- -H "Authorization: Bearer <ACCESS TOKEN>" -->
```sh
curl \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJlZmRiZTFhNDAzNmU0YjY2YTZiZjI1NDdmY2RlNDE1MCIsImlhdCI6MTY4NDQ3OTk2OSwiZXhwIjoxOTk5ODM5OTY5fQ.ZWDfUy705dTshZvGUSDYs2tJtAsiZlystG80Iy5ssOc" \
  -H "Content-Type: application/json" \
  http://shenshuxin.tpddns.cn:31/api/services
```

## 调用服务实例，例如改变switch的状态关开
```sh
curl \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJlZmRiZTFhNDAzNmU0YjY2YTZiZjI1NDdmY2RlNDE1MCIsImlhdCI6MTY4NDQ3OTk2OSwiZXhwIjoxOTk5ODM5OTY5fQ.ZWDfUy705dTshZvGUSDYs2tJtAsiZlystG80Iy5ssOc" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.example_load_platform_ssxswitchentity_attr_unique_id"}' \
  http://shenshuxin.tpddns.cn:31/api/services/switch/toggle

```

