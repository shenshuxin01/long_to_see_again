# 常用命令
- `cd /`
- `cp sourceFile targetFile`
- `mv`
- `kill -9 pid`
- `tar -zxvf file -C targetFile`
- `cat`
- `vim`
- `free -h`
- `du -h`
- `head -n`
- `tail -f `
- `more`
- `scp`
- `chmod a+x `
- `rm -rf *`
- `ps -ef`
- `ls -l -t`
- `grep -A 2 -B 3 '匹配关键词' filename`
- `grep -Eo '匹配关键词' filename #正则提取` 
- `awk -F " " '$0 ~ /正则表达式，注意不支持\d\s\n/ match($0,/正则/,a){print a[1],$1}'`
- `netstat -tlnp`
- `ln -s 文件 自定义link名字`
- `nohup homebridge -I > /var/log/homebridge.log 2>&1 &  #将标准错误 2 重定向到标准输出 &1 ，标准输出 &1 再被重定向输入到 runoob.log 文件中。`

# curl添加header请求
```shell
curl -H 'Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJwcm8tc2VydmVyIiwicHJpdmlsZWdlIjoiMyIsImV4cCI6MTY4MjEyNDkyNywidXNlciI6InNoZW5zaHV4aW4wMSJ9.glUFbVsc8nssmi1Ok6sBvssNn7RwKMu1FDiwjgjOKxg' -X GET http://shenshuxin.tpddns.cn:10/gateway/admin-server/ 
```

# 删除多余文件k8s java日志
```shell
rm -f ` ls -t | awk -F.  'BEGIN {k="aaa";print "删除文件开始"} NR==1 {k = $(NF-1) }  { if (!($0 ~ k)){ print $0,k}}'`
```

# shell命令的|、&、||、&&符号使用
## | 运算符
```shell
管道符号，是unix一个很强大的功能,符号为一条竖线:"|"。
#用法:
command 1 | command 2
他的功能是把第一个命令command 1执行的结果作为command2的输入传给command 2，例如:
 
ls -s|sort -nr
#-s 是file size，-n是numeric-sort，-r是reverse，反转
#该命令列出当前目录中的文档(含size)，并把输出送给sort命令作为输入，sort命令按数字递减的顺序把ls的输出排序。
```
## && 运算符:
```shell
#格式:
command1  && command2
&&左边的命令（命令1）返回真(即返回0，成功被执行）后，&&右边的命令（命令2）才能够被执行；
#换句话说，“如果这个命令执行成功&&那么执行这个命令”。
语法格式如下：

command1 && command2 && command3 ...
#1. 命令之间使用 && 连接，实现逻辑与的功能。
#2. 只有在 && 左边的命令返回真（命令返回值 $? == 0），&& 右边的命令才会被执行。
#3. 只要有一个命令返回假（命令返回值 $? == 1），后面的命令就不会被执行。

```

## || 运算符
```shell
#格式
command1 || command2
||则与&&相反。如果||左边的命令（command1）未执行成功，那么就执行||右边的命令（command2）；
#或者换句话说，“如果这个命令执行失败了||那么就执行这个命令。

#1. 命令之间使用 || 连接，实现逻辑或的功能。
#2. 只有在 || 左边的命令返回假（命令返回值 $? == 1），|| 右边的命令才会被执行。这和 c 语言中的逻辑或语法功能相同，即实现短路逻辑或操作。
# 3. 只要有一个命令返回真（命令返回值 $? == 0），后面的命令就不会被执行。

```

## ()、{}运算符
```shell
如果希望把几个命令合在一起执行，shell提供了两种方法。既可以在当前shell也可以在子shell中执行一组命令。
#子shell执行:
(command1;command2;command3....)        #多个命令之间用;分隔

#当前shell执行：
{ command1;command2;command3… }      #注意：在使用{}时，{}与命令之间必须使用一个空格
```
![1683697416896](image/linux-command/1683697416896.png)


# 查看电脑cpu架构，用于版本软件下载
![1683792074282](image/linux-command/1683792074282.png)
1. windows查看 cmd
`systeminfo | findstr "系统类型" `
2. linux查看 shell
`linux命令 lscpu | grep "Architecture"`


# date命令获取明天日期，时间差
```sh
# 明天零点日期 2023年 06月 28日 星期三 00:00:00 CST
date -d `date -d tomorrow +%Y%m%d`

# 明天零点日期的秒数 1687881600
date +%s -d `date -d tomorrow +%Y%m%d`

# 当前时间的秒数 1687831804
date +%s

# 计算明天零点距离当前时间还有多少秒
date1=`date -d tomorrow +%Y%m%d` \
    && date2=`date +%s -d $date1`\
    && date3=`date +%s`\
    && dateend=`expr $date2 - $date3`\
    || exit 0

```


# 删除病毒cpu1000%
```sh
[root@node101 .mint-xmr]# top | head
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
15870 root      20   0 4597844   2.0g      4 S  1017  3.3  52:05.95 xmrig

[root@node101 .mint-xmr]# ll /proc/15870/exe
lrwxrwxrwx. 1 root root 0 7月   5 12:17 /proc/15870/exe -> /var/tmp/.mint-xmr/xmrig

[root@node101 .mint-xmr]# cd /var/tmp/.mint-xmr/
[root@node101 .mint-xmr]# ll
总用量 2516
-rwxr-xr-x. 1 ssx ssx  261384 12月  4 2022 start
-rwxr-xr-x. 1 ssx ssx  263192 12月  4 2022 updat3
-rwxr-xr-x. 1 ssx ssx 2045432 3月  19 2022 xmrig

[root@node101 .mint-xmr]# crontab -l
@daily /var/tmp/.mint-xmr/start
@reboot /var/tmp/.mint-xmr/updat3 > /dev/null 2>&1 & disown
@monthly /var/tmp/.mint-xmr/updat3  > /dev/null 2>&1 & disown

[root@node101 .mint-xmr]# crontab -r && rm -rf /var/tmp/.mint-xmr  && kill -9 15870

[root@node101 tmp]# crontab -l
no crontab for root

```


# sed命令

sed 's/要被取代的字串/新的字串/g'

# 命令行循环
for i in {0..100};do curl -I "http://web-base:8083/test1?name=fffppp";done