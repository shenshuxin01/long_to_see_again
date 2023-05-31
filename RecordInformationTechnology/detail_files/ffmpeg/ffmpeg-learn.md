ffmpeg是一个处理视频语音的工具类，实现的功能有把视频切片，拉流，格式转换，等

# 把网络的rtsp流保存到本地m3u8格式的
```sh
#把直播流保存到本地，并且每60秒生成一个文件
ffmpeg.exe -i "rtsp://admin:XXXXXX@shenshuxin.tpddns.cn:33/h264/ch1/main/av_stream" -fflags flush_packets -flags -global_header -force_key_frames "expr:gte(t,n_forced*1)"  -hls_time 60 -hls_segment_filename ./ssxtmp/index%20d.ts ./ssxtmp/index.m3u8

#获取封面图片，每60秒替换一次这个图片demo-preview.jpg
ffmpeg.exe -i "rtsp://admin:XXXXXX@shenshuxin.tpddns.cn:33/h264/ch1/main/av_stream" -y -f image2 -r 1/1 -update 60 demo-preview.jpg
```