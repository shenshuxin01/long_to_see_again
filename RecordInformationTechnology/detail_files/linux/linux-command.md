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

