@echo off
@REM charset=GB18030 ������ļ��ŵ� C:\Users\shenshuxin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup·���� ʵ�ֿ��������� 
@REM 中文乱码使用 GB18030编码打开，因为windows使用的是此编码，bat脚本应保持一致
echo 'ִ��ÿ�ո���bing��ֽ-��ʼ'




timeout 10
if "%1"=="h" goto begin
start mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
:begin
 
python D:\appdata\ssx_private\long_to_see_again\learn-demo\bing_backgrounds_picture_everyday.py
echo 'ִ��ÿ�ո���bing��ֽ-���'