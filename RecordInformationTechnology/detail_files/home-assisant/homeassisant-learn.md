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

# Text to speech
tts:
  - platform: edge_tts
    language: zh-CN # Default language or voice (Optional)

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


# 开发插件
