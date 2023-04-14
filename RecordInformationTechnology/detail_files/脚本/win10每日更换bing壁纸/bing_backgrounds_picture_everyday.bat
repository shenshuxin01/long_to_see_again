@echo off
@REM charset=GB18030 ������ļ��ŵ� C:\Users\shenshuxin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup·���� ʵ�ֿ��������� 
@REM 中文乱码使用 GB18030编码打开，因为windows使用的是此编码，bat脚本应保持一致
echo 'ִ��ÿ�ո���bing��ֽ-��ʼ'




timeout 5

@REM if "%1"=="h" goto begin
@REM start mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
@REM :begin

pythonw  D:\appdata\ssx_private\long_to_see_again\RecordInformationTechnology\detail_files\脚本\win10每日更换bing壁纸\bing_backgrounds_picture_everyday.py

