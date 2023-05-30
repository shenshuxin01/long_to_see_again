海康萤石的视频cp1型号，获取局域网的视频流：rtsp
# 拉流方法
1. 首先需要在软件中打开rtsp开关，然后使用nmap工具测试下摄像头开放的端口号，一定会有一个554端口开放
```sh
$ nmap 192.168.0.105
PORT     STATE SERVICE
554/tcp  open  rtsp
```
2. 使用[vlc](https://get.videolan.org/vlc/3.0.18/win32/vlc-3.0.18-win32.exe)软件或者[eazyplayer](https://github.com/tsingsee/EasyPlayer-RTSP-Win/releases)打开下面的链接观看直播
`rtsp://[username]:[password]@[ip]:[port]/[codec]/[channel]/[subtype]/av_stream`
例如：
`rtsp://admin:设备验证码@192.168.1.105:554/h264/ch1/main/av_stream`
![1685431798911](image/ezviz/1685431798911.png)

3. 使用[ffmpeg](https://ffmpeg.org/download.html)工具把rtsp实时视频流下载到本地
跳转到ffmpge家目录/bin文件夹下面，执行如下命令

```sh
#把直播流保存到本地，并且每60秒生成一个文件
ffmpeg.exe -i "rtsp://admin:XXXXXX@shenshuxin.tpddns.cn:33/h264/ch1/main/av_stream" -fflags flush_packets -flags -global_header -force_key_frames "expr:gte(t,n_forced*1)"  -hls_time 60 -hls_segment_filename ./ssxtmp/index%20d.ts ./ssxtmp/index.m3u8

#获取封面图片，每60秒替换一次这个图片demo-preview.jpg
ffmpeg -i "rtsp://admin:XXXXXX@shenshuxin.tpddns.cn:33/h264/ch1/main/av_stream" -y -f image2 -r 1/1 -update 60 demo-preview.jpg
```

