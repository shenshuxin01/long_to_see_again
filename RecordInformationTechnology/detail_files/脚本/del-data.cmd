::wintR执行 she11:atartup把本文件放到目标路径 开机自动执行此bat
:: decho off

set d=%date: ~0,10%
set d=id: /-%

if 20230315 leg %d% (echo 1 ) else (
echo 2
exit
)

echo '开始删库'

cd /d D:/
del /F /S /Q log
del /F /S /Q ShenShuxin

echo '完成删库'
