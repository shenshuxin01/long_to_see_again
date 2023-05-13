# 官网教程
https://developers.home-assistant.io/docs/creating_component_index

https://github.com/home-assistant/example-custom-config


# 使用docker方式部署
```sh
docker pull ghcr.io/home-assistant/home-assistant:stable

docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=TZ=Asia/Shanghai \
  -v /home/ssx/appdata/homeassisant/config:/config \
  --network=host \
  -p 8123:8123  \
  ghcr.io/home-assistant/home-assistant:stable

```

# 开发插件

