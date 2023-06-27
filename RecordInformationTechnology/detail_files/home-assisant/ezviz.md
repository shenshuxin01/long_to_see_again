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
 
2. docker run --network=host  \
 -v /root/ssxtmp:/root/ssxtmp \
  jrottenberg/ffmpeg  \
 -v info  \
 -i 'rtsp://admin:AGXXZI@192.168.0.105:554/h264/ch1/main/av_stream' \
 -force_key_frames 'expr:gte(t,n_forced*1)'  \
 -hls_time 10 -hls_segment_filename \
 /root/ssxtmp/index_`date "+%Y%m%d%H%M%S"`_%20d.ts \
 /root/ssxtmp/index.m3u8

3. 部署到k8s
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ffmpeg
  name: ssx-ffmpeg-dm
  namespace: ssx
spec:
  replicas: 1
  selector: #标签选择器，与上面的标签共同作用
    matchLabels: #选择包含标签app:mysql的资源
      app: ffmpeg
  template: #这是选择或创建的Pod的模板
    metadata: #Pod的元数据
      labels: #Pod的标签，上面的selector即选择包含标签app:mysql的Pod
        app: ffmpeg
    spec: #期望Pod实现的功能（即在pod中部署）
      hostAliases: #给pod添加hosts网络
        - ip: "192.168.0.101"
          hostnames:
            - "node101"
        - ip: "192.168.0.102"
          hostnames:
            - "node102"
        - ip: "192.168.0.103"
          hostnames:
            - "node103"
      containers: #生成container,注意此pod部署了zookeeper和kafka.因为后者依赖前者。逻辑上来说需要有启动顺序，如果kafka启动报错未连接到zk,但是kebernetes会重启kafka容器
        - name: ssx-ffmpeg-c
          image: jrottenberg/ffmpeg  #配置阿里的镜像，直接pull即可
          imagePullPolicy: IfNotPresent
          volumeMounts: # zipkin默认不会持久化数据的，默认保存在内存中
            - mountPath: /etc/localtime   #时间同步
              name: c-v-path-lt
            - mountPath: /ssxtmp   #视频存储位置
              name: c-v-path-video
          command: ["bash"]
          args: ["-c","export date1=`date -d tomorrow +%Y%m%d` && export date2=`date +%s -d $date1` && export date3=`date +%s` && export dateend=`expr $date2 - $date3` && /usr/local/bin/ffmpeg -v info -t $dateend -i 'rtsp://admin:AGXXZI@192.168.0.105:554/h264/ch1/sub/av_stream' -force_key_frames 'expr:gte(t,n_forced*1)' -hls_time 60 -threads 1 -hls_list_size 0 -hls_segment_filename /ssxtmp/index_`date \"+%Y%m%d%H%M%S\"`_%20d.ts /ssxtmp/index_`date \"+%Y%m%d%H%M%S\"`.m3u8 || exit 1"] # 此配置会覆盖dockerFile的CMD参数,这里ffmpeg参数指定1，还有使用低码率的源视频流，都是为了降低cpu的转码率。目前大概在15%，如果使用默认的配置是200%   高清视频地址rtsp://admin:AGXXZI@192.168.0.105:554/h264/ch1/main/av_stream
      volumes:
        - name: c-v-path-lt
          hostPath:
            path: /etc/localtime   #时间同步
        - name: c-v-path-video
          hostPath:
            path: /home/app/apps/k8s/for_docker_volume/nginx/static-pages/nas/ffmpeg/current_video
      nodeSelector: #把此pod部署到指定的node标签上
        kubernetes.io/hostname: node101
```







