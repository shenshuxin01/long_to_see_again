# 官网教程
https://developers.home-assistant.io/docs/creating_component_index

https://github.com/home-assistant/example-custom-config

# 使用docker方式部署
https://www.home-assistant.io/installation/linux

```shell
docker run -d \
  --name homeassistant \
  --privileged \
  -p 8123:8123 \
  --restart=unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /home/ssx/appdata/homeassisant/config:/config \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable
  ```

# 集成第三方平台插件：cozylife
因为我买了他家的一个控制灯泡，需要集成下
https://github.com/cozylife/hass_cozylife_local_pull/issues/6


# 开发插件
