海康萤石的视频cp1型号，获取局域网的视频流：rtsp
# 拉流方法
1. 首先需要在软件中打开rtsp开关，然后使用nmap工具测试下摄像头开放的端口号，一定会有一个554端口开放
```sh
$ nmap 192.168.0.105
PORT     STATE SERVICE
554/tcp  open  rtsp
```
2. 使用[vlc](https://get.videolan.org/vlc/3.0.18/win32/vlc-3.0.18-win32.exe)软件或者eazyplayer打开下面的链接观看直播
`rtsp://[username]:[password]@[ip]:[port]/[codec]/[channel]/[subtype]/av_stream`
例如：
`rtsp://admin:设备验证码@192.168.1.105:554/h264/ch1/main/av_stream`




