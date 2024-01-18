版本控制软件 git \ svn
# svn
## java集成svn实现自动更新提交代码
[gitee例子](https://gitee.com/shenshuxin01/first_-spring-boot_-demo/tree/master/SVNKit_API_Demo)

# git
1. git删除remote origin
git remote rm origin

# github 连接ssh超时
在.ssh目录下新增文件 config
```sh
Host github.com
User git
Hostname ssh.github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa
Port 443
```
然后 ssh -T git@github.com
