@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
title Change-VNC-Password-OgidaniLLC
set KEY_FILE=%USERPROFILE%\.ssh\trading_vps_key

echo ======================================================
echo    VNC Password Change Tool
echo    OgidaniLLC
echo ======================================================
echo.
echo NOTE: Use letters and numbers only (avoid ^ ! % special chars)
echo.

set /p SERVER_IP="VPS IP Address: "
set /p NEW_PW="New VNC Password: "

if "%NEW_PW%"=="" (
    echo [ERROR] Password cannot be empty.
    pause
    exit /b 1
)

echo.
echo Changing VNC password...

if exist "%KEY_FILE%" (
    ssh -i "%KEY_FILE%" -o StrictHostKeyChecking=no root@%SERVER_IP% "docker exec trading-vps bash -c 'echo %NEW_PW% | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd' && docker restart trading-vps"
) else (
    ssh -o StrictHostKeyChecking=no root@%SERVER_IP% "docker exec trading-vps bash -c 'echo %NEW_PW% | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd' && docker restart trading-vps"
)

echo.
echo ======================================================
echo Password changed successfully!
echo New VNC Password: %NEW_PW%
echo ======================================================
pause
