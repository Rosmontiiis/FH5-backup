@echo off
title steamFH5ͬ������ Ciallo~��
echo ��ȷ��steam�����������������¼�˺�Ϊͬ���˺ź����
echo\
echo ���Ҫ�ָ��浵�뽫.tar.gz�ļ����빤������Ŀ¼��
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
    echo steam.exe·��: !steamPath!
) else (
    echo ���Ҳ���steam���̣�������steam����½������
    pause
    goto getRoot
)
set "steamRoot=!steamPath!"
for %%I in ("!steamPath!") do set "steamRoot=%%~dpI"
echo steam��Ŀ¼:!steamRoot!


set "log_file=!steamRoot!logs\connection_log.txt"

set "steamid="

for /f "tokens=11 delims=:[] " %%a in ('findstr /c:"'OK'" "%log_file%" ^| findstr /c:"[U:1:"') do (
    set "steamid=%%a"
)

echo\
echo ���µ�¼steam���Ѵ���Ϊ !steamid!


echo\
echo ��������1���ָ�����2(1/2)
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

rem -----------------------------------------------------------------------------����

:backup
title ���ݴ浵

set "ArchiveFile=!steamRoot!\userdata\!steamid!\1551360"
if exist "!ArchiveFile!" (
    echo ���ҵ�FH5�浵
) else (
    echo �浵�����ڣ�����浵�Ƿ�����
    pause
    goto end
)
echo\
echo ���ڴ���浵...
tar -czf ".\backup.tar.gz" -C "!ArchiveFile!" .
echo\
echo ������
for %%I in (".\backup.tar.gz") do set "fileSize=%%~zI"
set /a fileSizeMB=fileSize / (1024 * 1024)
echo �����Ĵ浵�ļ���СΪ: %fileSizeMB% MB
pause
goto end

rem -----------------------------------------------------------------------------�ָ�

:restore
title �ָ��浵

mkdir 1551360
mkdir "!steamRoot!\userdata\!steamid!\1551360"
echo ��ѹ��
tar -xzf backup.tar.gz -C 1551360
xcopy /e /y "1551360" "!steamRoot!\userdata\!steamid!\1551360"
rmdir /s /q ".\1551360"
echo\
echo ��ѹ���ָ��ɹ�
pause
goto end




:end
exit