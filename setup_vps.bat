@echo off
setlocal enabledelayedexpansion
title Linux VPS Auto Setup | OgidaniLLC
set GITHUB_USER=OgidaniLLC
set REPO_NAME=linux-vps-portal
set SECRET_PREFIX=TRADING

echo ======================================================
echo    Linux VPS 爆速セットアップツール (Windows版)
echo    OgidaniLLC
echo ======================================================
echo.

set /p SERVER_IP="[1/3] VPSのIPアドレスを入力: "
set /p INPUT_KEY="[2/3] 今月の合言葉を入力: "

set YYYY=%date:~0,4%
set MM=%date:~5,2%
set CORRECT_KEY=%SECRET_PREFIX%%YYYY%%MM%

if not "%INPUT_KEY%"=="%CORRECT_KEY%" (
    echo.
    echo [エラー] 合言葉が違います。担当者にお問い合わせください。
    pause
    exit /b 1
)

set /p VNC_PW="[3/3] 接続パスワード (空白なら vps12345): "
if "%VNC_PW%"=="" set VNC_PW=vps12345

echo.
echo 自動構築を開始します...
echo サーバー: %SERVER_IP%
echo.

ssh root@%SERVER_IP% "sudo apt update && curl -fsSL https://get.docker.com | sh && mkdir -p trading-vps && cd trading-vps && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/docker-compose.yml && sed -i 's/VNC_PW=vps12345/VNC_PW=%VNC_PW%/g' docker-compose.yml && docker compose up -d"

echo.
echo ======================================================
echo 完了しました！
echo VNC接続URL: http://%SERVER_IP%:6080/vnc.html
echo ======================================================
pause
