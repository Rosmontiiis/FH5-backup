@echo off
title steamFH5同步工具 Ciallo~★
echo 请确保steam正在运行中且最近登录账号为同步账号后继续
echo\
echo 如果要恢复存档请将.tar.gz文件放入工具所在目录中
echo\
pause
cls
setlocal enabledelayedexpansion

:getRoot

set "steamPath="
for /f "tokens=2 delims==" %%a in ('wmic process where "name='Steam.exe'" get ExecutablePath /format:value ^| find "="') do (
    set "steamPath=%%a"
)
if not "!steamPath!"=="" (
    echo steam.exe路径: !steamPath!
) else (
    echo 查找不到steam进程！请运行steam并登陆后重试
    pause
    goto getRoot
)
set "steamRoot=!steamPath!"
for %%I in ("!steamPath!") do set "steamRoot=%%~dpI"
echo steam根目录:!steamRoot!


set "log_file=!steamRoot!logs\connection_log.txt"

set "steamid="

for /f "tokens=11 delims=:[] " %%a in ('findstr /c:"'OK'" "%log_file%" ^| findstr /c:"[U:1:"') do (
    set "steamid=%%a"
)

echo\
echo 最新登录steam好友代码为 !steamid!


echo\
echo 备份输入1，恢复输入2(1/2)
set /p choice=

if /i "%choice%"=="1" (
    cls
    goto backup
) else if /i "%choice%"=="2" (
    cls
    goto restore
) else (
    echo Invalid choice. Please enter yes or no.
)
goto end

rem -----------------------------------------------------------------------------备份

:backup
title 备份存档

set "ArchiveFile=!steamRoot!\userdata\!steamid!\1551360"
if exist "!ArchiveFile!" (
    echo 查找到FH5存档
) else (
    echo 存档不存在！请检查存档是否正常
    pause
    goto end
)
echo\
echo 正在打包存档...
tar -czf ".\backup.tar.gz" -C "!ArchiveFile!" .
echo\
echo 打包完成
for %%I in (".\backup.tar.gz") do set "fileSize=%%~zI"
set /a fileSizeMB=fileSize / (1024 * 1024)
echo 打包后的存档文件大小为: %fileSizeMB% MB
pause
goto end

rem -----------------------------------------------------------------------------恢复

:restore
title 恢复存档

mkdir 1551360
mkdir "!steamRoot!\userdata\!steamid!\1551360"
echo 解压中
tar -xzf backup.tar.gz -C 1551360
xcopy /e /y "1551360" "!steamRoot!\userdata\!steamid!\1551360"
rmdir /s /q ".\1551360"
echo\
echo 解压并恢复成功
pause
goto end




:end
exit
