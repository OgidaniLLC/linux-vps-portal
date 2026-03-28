@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
title Linux-VPS-Auto-Setup-OgidaniLLC
set GITHUB_USER=OgidaniLLC
set REPO_NAME=linux-vps-portal
set SECRET_PREFIX=TRADING
set KEY_FILE=%USERPROFILE%\.ssh\trading_vps_key

echo ======================================================
echo    Linux VPS Auto Setup Tool (Windows)
echo    OgidaniLLC
echo ======================================================
echo.

set /p SERVER_IP="[1/3] VPS IP Address: "
set /p INPUT_KEY="[2/3] Secret Key: "

set YYYY=%date:~0,4%
set MM=%date:~5,2%
set CORRECT_KEY=%SECRET_PREFIX%%YYYY%%MM%

if not "%INPUT_KEY%"=="%CORRECT_KEY%" (
    echo.
    echo [ERROR] Invalid secret key. Please contact support.
    pause
    exit /b 1
)

set /p VNC_PW="[3/3] VNC Password (default: vps12345, avoid ^ ! % special chars): "
if "%VNC_PW%"=="" set VNC_PW=vps12345

echo.
echo [Setup] Configuring SSH key authentication...
if not exist "%KEY_FILE%" (
    ssh-keygen -t ed25519 -f "%KEY_FILE%" -N "" > nul 2>&1
)
set /p PUBKEY=<"%KEY_FILE%.pub"
ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=yes root@%SERVER_IP% "mkdir -p ~/.ssh && echo %PUBKEY% >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

echo.
echo [Setup] Starting VPS build (this takes 10-15 minutes)...
echo Server: %SERVER_IP%
echo.

ssh -i "%KEY_FILE%" -o ServerAliveInterval=60 -o ServerAliveCountMax=30 -o StrictHostKeyChecking=no root@%SERVER_IP% "sudo apt update && curl -fsSL https://get.docker.com | sh && mkdir -p trading-vps && cd trading-vps && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/docker-compose.yml && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/Dockerfile && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/startup.sh && chmod +x startup.sh && sed -i 's/VNC_PW=vps12345/VNC_PW=%VNC_PW%/g' docker-compose.yml && docker compose up -d --build && echo SETUP_DONE"
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] VPS setup failed. Please check your network connection.
    pause
    exit /b 1
)

echo.
echo [Setup] Transferring Japanese fonts...
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
        scp -i "%KEY_FILE%" -o StrictHostKeyChecking=no "C:\Windows\Fonts\%%F" root@%SERVER_IP%:/tmp/%%F
        ssh -i "%KEY_FILE%" -o StrictHostKeyChecking=no root@%SERVER_IP% "docker cp /tmp/%%F trading-vps:/root/.wine/drive_c/windows/Fonts/%%F"
    )
)
echo [Setup] Font transfer complete.

echo.
echo ======================================================
echo Setup complete!
echo VNC URL: http://%SERVER_IP%:6080/vnc.html
echo VNC Password: %VNC_PW%
echo ======================================================
pause
