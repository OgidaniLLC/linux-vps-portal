@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
title Linux-VPS-Auto-Setup-OgidaniLLC
set GITHUB_USER=OgidaniLLC
set REPO_NAME=linux-vps-portal
set KEY_FILE=%USERPROFILE%\.ssh\trading_vps_key

cls
echo ======================================================
echo    Linux VPS Auto Setup Tool
echo    OgidaniLLC
echo ======================================================
echo.
echo  This tool will automatically set up your trading VPS.
echo  Please follow the instructions on screen.
echo.
echo ======================================================
echo.

set /p SERVER_IP="VPS IP Address: "
set /p INPUT_KEY="Secret Key: "

if not "%INPUT_KEY%"=="LinuxVPS8675" (
    echo.
    echo [ERROR] Invalid secret key. Please contact support.
    pause
    exit /b 1
)

set VNC_PW=vps12345

cls
echo ======================================================
echo  STEP 1/4 - SSH Authentication Setup
echo ======================================================
echo.
echo  We will now register a secure key to your VPS.
echo  You will be asked for your VPS password ONCE.
echo  After this, no more passwords are needed.
echo.
echo  Starting in 3 seconds...
timeout /t 3 /nobreak > nul

if not exist "%KEY_FILE%" (
    ssh-keygen -t ed25519 -f "%KEY_FILE%" -N "" > nul 2>&1
)
set /p PUBKEY=<"%KEY_FILE%.pub"
ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=yes root@%SERVER_IP% "mkdir -p ~/.ssh && echo %PUBKEY% >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

cls
echo ======================================================
echo  STEP 1/4 - Complete!
echo ======================================================
echo.
echo  SSH key registered successfully.
echo  No more password prompts for the rest of setup.
echo.
timeout /t 3 /nobreak > nul

cls
echo ======================================================
echo  STEP 2/4 ^& 3/4 - Building Trading Environment
echo ======================================================
echo.
echo  Now installing Docker and building the desktop.
echo  This will take 10-15 minutes.
echo  Please do NOT close this window.
echo.
echo  Starting in 3 seconds...
timeout /t 3 /nobreak > nul

ssh -i "%KEY_FILE%" -o ServerAliveInterval=60 -o ServerAliveCountMax=30 -o StrictHostKeyChecking=no root@%SERVER_IP% "sudo apt update && curl -fsSL https://get.docker.com | sh && mkdir -p trading-vps && cd trading-vps && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/docker-compose.yml && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/Dockerfile && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/startup.sh && chmod +x startup.sh && sed -i 's/VNC_PW=vps12345/VNC_PW=%VNC_PW%/g' docker-compose.yml && docker compose up -d --build && echo SETUP_DONE"
if %ERRORLEVEL% neq 0 (
    cls
    echo [ERROR] VPS setup failed.
    echo Please check TROUBLESHOOTING.md or contact support.
    pause
    exit /b 1
)

cls
echo ======================================================
echo  STEP 2/4 ^& 3/4 - Complete!
echo ======================================================
echo.
echo  Docker installed and desktop environment is ready.
echo.
timeout /t 3 /nobreak > nul

cls
echo ======================================================
echo  STEP 4/4 - Installing Japanese Fonts
echo ======================================================
echo.
echo  Transferring fonts from your PC to VPS.
echo  Please wait...
echo.
timeout /t 3 /nobreak > nul

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

ssh -i "%KEY_FILE%" -o StrictHostKeyChecking=no root@%SERVER_IP% "docker exec trading-vps bash -c 'xdg-settings set default-web-browser chromium.desktop 2>/dev/null || update-alternatives --set x-www-browser /usr/bin/chromium'" > nul 2>&1

cls
echo ======================================================
echo  ALL STEPS COMPLETE!
echo ======================================================
echo.
echo  Your trading VPS is ready.
echo.
echo  Open your browser and go to:
echo.
echo    http://%SERVER_IP%:6080/vnc.html
echo.
echo  VNC Password: %VNC_PW%
echo.
echo  Next: Install your trading software (MT4/MT5)
echo        from your broker's website inside the desktop.
echo.
echo ======================================================
pause
