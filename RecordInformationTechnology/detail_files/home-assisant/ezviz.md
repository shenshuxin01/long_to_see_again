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
ffmpeg.exe -i "rtsp://admin:XXXXXX@shenshuxin.tpddns.cn:33/h264/ch1/main/av_stream" -y -f image2 -r 1/1 -update 60 demo-preview.jpg
```

![1685513836169](image/ezviz/1685513836169.png)

# 萤石摄像头云台控制（上下左右）API接口
[官网接口文档](https://open.ys7.com/doc/zh/book/index/device_ptz.html)
```txt
HTTP请求报文
POST /api/lapp/device/ptz/start HTTP/1.1
Host: open.ys7.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.4g01l53x0w22xbp30ov33q44app1ns9m&deviceSerial=502608888&channelNo=1&direction=2&speed=1

返回数据
{
    "code": "200",
    "msg": "操作成功!"
}
```
token需要在官网获取：https://open.ys7.com/console/application.html
![1685515261991](image/ezviz/1685515261991.png)

## 云台api详细步骤
1. 登录官网获取appkey secret然后调用获取token接口
    ```sh
    curl --location --request POST 'https://open.ys7.com/api/lapp/token/get?appKey=XXXX&appSecret=XXXXXXX' \
    --header 'Content-Type: application/json' \
    --header 'Accept: */*' \
    --data-raw ''
    ```

2. 获取摄像头设备序列号
![1685515939076](image/ezviz/1685515939076.png)

3. 启动云台旋转

| 参数名 | 类型 | 描述 | 是否必选 |
| --- | --- | --- | --- |
| accessToken | String | 授权过程获取的access_token | Y |
| deviceSerial | String | 设备序列号,存在英文字母的设备序列号，字母需为大写 | Y
| channelNo | int | 通道号 | Y
| direction | int | 操作命令：0-上，1-下，2-左，3-右，4-左上，5-左下，6-右上，7-右 | Y
| speed | int | 云台速度：0-慢，1-适中，2-快，海康设备参数不可为0 | Y
```sh
curl --location --request POST 'https://open.ys7.com/api/lapp/device/ptz/start?accessToken=XXXXX&deviceSerial=BA2294767&channelNo=1&direction=2&speed=1' 
```

4. 停止云台旋转
```sh
curl --location --request POST 'https://open.ys7.com/api/lapp/device/ptz/stop?accessToken=XXXXX&deviceSerial=BA2294767&channelNo=1'
```

# docker方式执行ffmpeg
1. docker pull jrottenberg/ffmpeg
 
2. docker run --network=host  jrottenberg/ffmpeg -v info -i 'rtsp://admin:AGXXZI@192.168.0.105:554/h264/ch1/main/av_stream' -fflags flush_packets -flags -global_header -force_key_frames 'expr:gte(t,n_forced*1)' -hls_time 5 -hls_segment_filename /index%20d.ts /index.m3u8

