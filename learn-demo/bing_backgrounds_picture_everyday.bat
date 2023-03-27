@echo off
@REM charset=GB18030 把这个文件放到 C:\Users\shenshuxin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup路径下 实现开机自启动 

echo '执行每日更换bing壁纸-开始'




timeout 10
if "%1"=="h" goto begin
start mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
:begin
 
python D:\appdata\ssx_private\long_to_see_again\learn-demo\bing_backgrounds_picture_everyday.py
echo '执行每日更换bing壁纸-完成'