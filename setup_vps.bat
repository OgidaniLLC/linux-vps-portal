@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
title Linux-VPS-Auto-Setup-OgidaniLLC
set GITHUB_USER=OgidaniLLC
set REPO_NAME=linux-vps-portal
set SECRET_PREFIX=TRADING
set KEY_FILE=%USERPROFILE%\.ssh\trading_vps_key

echo ======================================================
echo    Linux VPS Auto Setup Tool
echo    OgidaniLLC
echo ======================================================
echo.
echo  This tool will automatically:
echo  [1] Authenticate with your VPS
echo  [2] Install Docker
echo  [3] Build the trading desktop environment
echo  [4] Install Japanese fonts
echo.
echo ======================================================
echo.

set /p SERVER_IP="VPS IP Address: "
set /p INPUT_KEY="Secret Key: "

set YYYY=%date:~0,4%
set MM=%date:~5,2%
set CORRECT_KEY=%SECRET_PREFIX%%YYYY%%MM%

if not "%INPUT_KEY%"=="%CORRECT_KEY%" (
    echo.
    echo [ERROR] Invalid secret key. Please contact support.
    pause
    exit /b 1
)

set VNC_PW=vps12345

echo.
echo ======================================================
echo  STEP 1/4 - Setting up SSH key authentication
echo  (You will be asked for your VPS password once)
echo ======================================================
if not exist "%KEY_FILE%" (
    ssh-keygen -t ed25519 -f "%KEY_FILE%" -N "" > nul 2>&1
)
set /p PUBKEY=<"%KEY_FILE%.pub"
ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=yes root@%SERVER_IP% "mkdir -p ~/.ssh && echo %PUBKEY% >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
echo  SSH key registered. No more password prompts.

echo.
echo ======================================================
echo  STEP 2/4 - Installing Docker on VPS
echo  Please wait...
echo ======================================================

echo.
echo ======================================================
echo  STEP 3/4 - Building trading desktop environment
echo  This step takes 10-15 minutes. Please wait...
echo ======================================================
echo.

ssh -i "%KEY_FILE%" -o ServerAliveInterval=60 -o ServerAliveCountMax=30 -o StrictHostKeyChecking=no root@%SERVER_IP% "sudo apt update && curl -fsSL https://get.docker.com | sh && mkdir -p trading-vps && cd trading-vps && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/docker-compose.yml && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/Dockerfile && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/startup.sh && chmod +x startup.sh && sed -i 's/VNC_PW=vps12345/VNC_PW=%VNC_PW%/g' docker-compose.yml && docker compose up -d --build && echo SETUP_DONE"
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] VPS setup failed. Please check TROUBLESHOOTING.md or contact support.
    pause
    exit /b 1
)
echo  Desktop environment is ready.

echo.
echo ======================================================
echo  STEP 4/4 - Transferring Japanese fonts
echo  Please wait...
echo ======================================================
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
        scp -i "%KEY_FILE%" -o StrictHostKeyChecking=no "C:\Windows\Fonts\%%F" root@%SERVER_IP%:/tmp/%%F > nul 2>&1
        ssh -i "%KEY_FILE%" -o StrictHostKeyChecking=no root@%SERVER_IP% "docker cp /tmp/%%F trading-vps:/root/.wine/drive_c/windows/Fonts/%%F" > nul 2>&1
    )
)
echo  Japanese fonts installed.

echo.
echo ======================================================
echo  Setup Complete!
echo.
echo  Open your browser and go to:
echo  http://%SERVER_IP%:6080/vnc.html
echo.
echo  VNC Password: %VNC_PW%
echo.
echo  Next step: Install your trading software (MT4/MT5)
echo  from your broker's website inside the VNC desktop.
echo ======================================================
pause
