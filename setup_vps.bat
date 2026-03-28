@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
title Linux-VPS-Auto-Setup-OgidaniLLC
set GITHUB_USER=OgidaniLLC
set REPO_NAME=linux-vps-portal
set SECRET_PREFIX=TRADING

echo ======================================================
echo    Linux VPS Auto Setup Tool (Windows)
echo    OgidaniLLC
echo ======================================================
echo.

set /p SERVER_IP="[1/3] VPS IP Address: "
set /p INPUT_KEY="[2/3] Password (Secret Key): "

set YYYY=%date:~0,4%
set MM=%date:~5,2%
set CORRECT_KEY=%SECRET_PREFIX%%YYYY%%MM%

if not "%INPUT_KEY%"=="%CORRECT_KEY%" (
    echo.
    echo [ERROR] Invalid secret key. Please contact support.
    pause
    exit /b 1
)

set /p VNC_PW="[3/3] VNC Password (default: vps12345): "
if "%VNC_PW%"=="" set VNC_PW=vps12345

echo.
echo Starting VPS setup...
echo Server: %SERVER_IP%
echo.

ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=30 -o StrictHostKeyChecking=no root@%SERVER_IP% "sudo apt update && curl -fsSL https://get.docker.com | sh && mkdir -p trading-vps && cd trading-vps && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/docker-compose.yml && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/Dockerfile && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/startup.sh && chmod +x startup.sh && sed -i 's/VNC_PW=vps12345/VNC_PW=%VNC_PW%/g' docker-compose.yml && docker compose up -d --build && echo SETUP_DONE"
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] VPS setup failed. Please check your network connection.
    pause
    exit /b 1
)

echo.
echo Transferring Japanese fonts...
for %%F in (
    msgothic.ttc
    meiryo.ttc
    meiryob.ttc
    meiryoi.ttc
    meiryobi.ttc
    YuGothM.ttc
    YuGothB.ttc
    YuGothL.ttc
    yumin.ttf
    yumindb.ttf
    yuminl.ttf
    msmincho.ttc
) do (
    if exist "C:\Windows\Fonts\%%F" (
        scp -o StrictHostKeyChecking=no "C:\Windows\Fonts\%%F" root@%SERVER_IP%:/tmp/%%F
        ssh -o StrictHostKeyChecking=no root@%SERVER_IP% "docker cp /tmp/%%F trading-vps:/root/.wine/drive_c/windows/Fonts/%%F"
    )
)
echo Font transfer complete.

echo.
echo ======================================================
echo Setup complete!
echo VNC URL: http://%SERVER_IP%:6080/vnc.html
echo VNC Password: %VNC_PW%
echo ======================================================
pause
