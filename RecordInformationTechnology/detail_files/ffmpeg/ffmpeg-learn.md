ffmpeg是一个处理视频语音的工具类，实现的功能有把视频切片，拉流，格式转换，等
# 把网络的rtsp流保存到本地m3u8格式的
```sh
#把直播流保存到本地，并且每60秒生成一个文件
ffmpeg.exe -i "rtsp://admin:XXXXXX@shenshuxin.tpddns.cn:33/h264/ch1/main/av_stream" -fflags flush_packets -flags -global_header -force_key_frames "expr:gte(t,n_forced*1)"  -hls_time 60 -hls_segment_filename ./ssxtmp/index%20d.ts ./ssxtmp/index.m3u8
#获取封面图片，每60秒替换一次这个图片demo-preview.jpg
ffmpeg.exe -i "rtsp://admin:XXXXXX@shenshuxin.tpddns.cn:33/h264/ch1/main/av_stream" -y -f image2 -r 1/1 -update 60 demo-preview.jpg
```
# 直播流HLS
m3u8格式的，然后是一个文件， “EVENT” 或者 “VOD”
## 前言
M3U8 作为一种常见的视频封装格式，具有广泛的使用场景，不仅被应用到点播场景中，也被应用到直播场景中。特别是点播场景，目前主流的视频点播网站大多都是使用 M3U8 方案。
## 正文
格式简介
M3U8 视频封装格式其实是一个统称，它实际上是由 m3u8 索引文件和若干个 ts 分片文件组成的，视频编码为 H264，音频编码为 AAC。很多时候大家可能对 HLS（Http Live Streaming）的说法更加熟悉。是的，HLS 是由苹果公司提出的基于 HTTP 的流媒体网络传输协议，是苹果公司 QuickTime X 和 iPhone 软件系统的一部分。HLS 不仅支持 ts 分片，还支持 mp4 分片，但是后者一般太常见，主流的 HLS 方案使用的还是 ts 分片。下面是一张来自苹果官网的示意图。
## 工作原理
M3U8 视频封装格式的工作原理就是把整个流分成一个个小的基于 HTTP 的 ts 视频文件下载下来，每次只下载一部分 ts 视频文件。当媒体流正在播放时，客户端可以选择从许多不同的备用源中以不同的速率下载同样的资源，允许流媒体会话适应不同的数据速率动态切换。在开始一个流媒体会话时，客户端会下载一个包含元数据的 m3u8 文件，用于寻找可用的 ts 媒体流。
## 结构组成
上文已经讲到，M3U8 封装格式是由 m3u8 索引文件和若干个 ts 视频文件组成的，其中，m3u8 文件作为索引文件，在 M3U8 整个视频封装格式中扮演着重要角色，因为它串联了所有的 ts 分片文件。
## m3u8 索引文件有特定的格式和类型标签，下面来看一个非常简单的实例文件：
```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:8
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-DISCONTINUITY
#EXTINF:7.749667,
index_0000.ts
#EXTINF:5.875000,
index_0001.ts
#EXTINF:3.916667,
index_0002.ts
#EXT-X-ENDLIST
```
从上面的文件可以看到几个 #开头的标签，接下来分别介绍这几个标签字段的含义。
## EXTM3U
EXTM3U 字段是一个类型指定标签，用来表示这个文件属于 m3u8 类型文件。书写格式如下：
#EXTM3U
所有的 m3u8 文件都包含这个标签，而且文件的第一行就是这个标签。
## EXT-X-VERSION
EXT-X-VERSION 字段是一个表示版本号标签，上文示例文件中的 3，表示该 m3u8 文件的版本号是 3。书写格式如下：
#EXT-X-VERSION:<n>
其中，n 是版本号。目前，m3u8 文件最为常见的版本都是 3。使用 ffmpeg 工具录制 rtsp 视频流创建 m3u8 文件时，使用的版本号就是 3。版本 3 的特点就是支持浮点型的 EXTINF 的数值。
## EXT-X-TARGETDURATION
EXT-X-TARGETDURATION 字段是用来表示所有分片最大时长的标签，注意这是一个四舍五入的值，如果 m3u8 文件中分片列表中分片最大的时长是 8.02，那么 EXT-X-TARGETDURATION 字段的值是 8。书写格式如下：
#EXT-X-TARGETDURATION: 
其中，s 是分片最大时长，单位是秒。比如上文 m3u8 示例文件中，一共有三个 ts 视频分片，其中时长最长的是 7.749667 秒，因此，EXT-X-TARGETDURATION 字段的值就是 8 。这就很好的佐证了我们的结论。
## EXT-X-MEDIA-SEQUENCE
EXT-X-MEDIA-SEQUENCE 字段是一个分片参考序列标签，当 m3u8 文件用于直播场景时，会把这个标签的值作为参考，进而播放对应的序列号的分片。但是，这样的话，就要求所有的 ts 分片序号都是动态变化的，且不能重复。书写格式如下：
 #EXT-X-MEDIA-SEQUENCE:<number>
其中，number 是分片序列号。尽管该标签规定了播放的分片序号，但是也存在特例，比如，如果 m3u8 索引文件中不存在 EXT-X-ENDLIST 标签，那么播放器都会从倒数第三个视频分片开始播放，当文件列表中的分片数量不足三片时会停止播放。但是，也有一些播放特殊处理之后也支持继续播放。
当 m3u8 文件列表中的前一个视频分片和下一个视频分片不是连续的时候，使用播放器播放时很可能是失败，这个时候就需要用来一个神奇的字段标签——EXT-X-DISCONTINUITY，它可以轻松解决这个问题。
## EXTINF
EXTINF 字段是用来表示每个 ts 视频分片时长的标签。书写格式如下：
#EXTINF:<duration>,[<title>]
其中，duration 字段是分片时长，单位是秒；title 字段是可选描述信息。每个 ts 视频分片都有自己的 EXTINF 标签，比如上文示例文件中，index_0000.ts 视频文件的时长是 7.749667 秒，index_0001.ts 视频文件的时长是 5.875000 秒，index_0002.ts 视频文件的时长是 3.916667 秒。EXTINF 标签中除了文件时长信息之外，还可以包含其他描述信息，但是主要需要使用逗号分隔。
EXTINF 标签中的 ts 视频分片可以像上文的示例文件一样，直接填写文件名称或者相对路径，也可以是视频文件绝对路径，当然也可以是视频文件的网络点播地址。
## EXT-X-ENDLIST
EXT-X-ENDLIST 字段是表示 m3u8 文件结束的标签。书写格式如下：
#EXT-X-ENDLIST
该标签一般会用在 m3u8 文件的最后一行，也是用来区分某个 m3u8 文件是用于点播场景还是直播场景的标识。点播场景中的 m3u8 文件包行 EXT-X-ENDLIST 标签，直播场景中的 m3u8 文件没有 EXT-X-ENDLIST 标签。
## EXT-X-STREAM-INF
EXT-X-STREAM-INF 字段是用来表示一个可变视频流的标签。书写格式如下：
#EXT-X-STREAM-INF:<attribute-list><URI>
其中，attribute-list 包含多个属性定义，下面分别介绍一下。
## BANDWIDTH 字段用来表示可变视频流的码率，一般来说，EXT-X-STREAM-INF 标签出现时，这个字段是不可缺少的。
AVERAGE-BANDWIDTH 字段用来表示可变视频流的平均码率，该属性是一个可选属性。
CODECS 字段用来表示可变视频流的媒体编码信息，一般包括视频编码和音频编码信息。比如，如果是音频编码为 AAC-LC，视频编码为 H.264 Main Profile Level 3.0 的可变视频流，那么，它的 CODECS 字段的值应该为“mp4a.40.2,avc1.4d401e”。一般来说，EXT-X-STREAM-INF 标签出现时，这个属性是应该被标明的。
RESOLUTION 字段用来表示可变视频流的分辨率，一般来说，EXT-X-STREAM-INF 标签出现时，这个属性是推荐使用的。
FRAME-RATE 字段用来表示可变视频流中所有视频的最大帧率，该属性是一个可选属性。
HDCP-LEVEL 字段用来表示可变视频流的高带宽数字内容保护级别，该属性的值是一个枚举字符串，可用值为“TYPE-0”和“NONE”。其中，“TYPE-0” 表示播放的视频内容必须经过高带宽数字内容保护，否则会播放失败。“NONE”表示不限制视频内容的保护级别。该属性是一个可选属性。
AUDIO 字段用来表示可变媒体流的媒体类型，用来表示播放的内容是音频格式，该属性是一个可选属性。
VIDEO 字段用来表示可变媒体流的媒体类型，用来表示播放的内容是视频格式，该属性是一个可选属性。
SUBTITLES 字段用来表示可变媒体流的媒体类型，用来表示显示的内容是字幕内容，该属性是一个可选属性。
CLOSED-CAPTIONS 字段用来表示可变媒体流的媒体类型，用来表示显示的内容是旁白字幕，主要是为了考虑由听力障碍的用户，该属性是一个可选属性。
上面介绍了那么多，下面看一个例子：
#EXTM3U   
#EXT-X-STREAM-INF:BANDWIDTH=1280000,AVERAGE-BANDWIDTH=1000000  http://example.com/low.m3u8   
#EXT-X-STREAM-INF:BANDWIDTH=2560000,AVERAGE-BANDWIDTH=2000000  http://example.com/mid.m3u8   
#EXT-X-STREAM-INF:BANDWIDTH=7680000,AVERAGE-BANDWIDTH=6000000  http://example.com/hi.m3u8   
#EXT-X-STREAM-INF:BANDWIDTH=65000,CODECS="mp4a.40.5"  
http://example.com/audio-only.m3u8
通过上面的示例文件，我们可以看到主 m3u8 文件包括了四个子 m3u8 文件，分别是最高码率为 1.28 MB、平均码率为 1 MB 的 low.m3u8，最高码率为 2.56 MB、平均码率为 2 MB 的 mid.m3u8，最高码率为 7.68 MB、平均码率为 6 MB 的 hi.m3u8，最高码率为 65K、音频编码为 HE-AAC 的 audio-only.m3u8。
EXT-X-BYTERANGE
EXT-X-BYTERANGE 字段是用来表示 URI 对应文件资源的一个子集的标签。书写格式如下：
EXT-X-BYTERANGE 
其中，n 表示子集的字节数，o 为可选项，标明子集的起始位置，相当于从资源开始出计算的偏移量。若 o 未定义，则其开始位置为上一个子集的结束位置的下一个字节。注意，这个标签在 M3U8 版本号 4.0 及以上才有。
EXT-X-PLAYLIST-TYPE
EXT-X-PLAYLIST-TYPE 字段是用来播放列表的类型信息。书写格式如下：
#EXT-X-PLAYLIST-TYPE 
其中，type-enum 是字符串枚举类型，“EVENT” 或者 “VOD”。该属性是一个可选属性。
结论
本文重点总结和介绍了 M3U8 视频封装格式的工作原理和常用标签，由于自带分片能力，在超大视频文件存储方面，M3U8 格式具备先天的优势，因此，很多视频点播网站广泛采取该封装格式。还有更多后续继续分享，欢迎关注。


## EXT-X-DISCONTINUITY
让播放器重新初始化。目的连接不连续的视频片段
```
应用场景：
  1）轮播不用的影片。
  2）插入广告
#EXTM3U
#EXT-X-TARGETDURATION:10
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10,
400-clipA-0.ts
#EXTINF:10,
400-clipA-1.ts
#EXTINF:5,
400-clipA-2.ts

#EXT-X-DISCONTINUITY
#EXTINF:10,
400-advert0.ts
#EXTINF:3,
400-advert1.ts

#EXT-X-DISCONTINUITY
#EXTINF:10,
400-clipB-0.ts
#EXTINF:10,
400-clipB-1.ts
#EXTINF:5,
400-clipB-2.ts

#EXT-X-ENDLIST
```

# ffplay使用
远程执行添加变量 export DISPLAY=:0

# ffmpeg切片视频
ffmpeg -i ~/index.mp4 -c:v h264 -flags +cgop -g 30 -hls_time 5 -hls_list_size 0 -hls_segment_filename index%3d.ts index.m3u8