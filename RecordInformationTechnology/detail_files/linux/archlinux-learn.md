# arch安装.deb软件包
1. 使用pacman或者yay安装`debtap`工具： `sudo pacman -S debtap`
2. 更新debtap：`sudo debtap -u`
3. 处理下载的deb软件包：`debtap xxxxxx.deb` (运行中会提示输入包名)
4. 使用pacman安装软件： `sudo pacman -U xxxxx.zst`

## 安装vscode.deb包举例
1. 打开官网[https://code.visualstudio.com/Download](https://code.visualstudio.com/Download)下载deb包
2. 下载后打开文件夹
```shell
$ sudo yay -S debtap

$ sudo debtap -u

$ ls
code_1.79.0-1686149120_amd64.deb

$ debtap ./code_1.79.0-1686149120_amd64.deb

$ ls
code_1.79.0-1686149120_amd64.deb
code-1.79.0-1-x86_64.pkg.tar.zst

$ sudo pacman -U ./code-1.79.0-1-x86_64.pkg.tar.zst

```