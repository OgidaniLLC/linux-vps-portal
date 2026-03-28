@echo off
setlocal enabledelayedexpansion
title Linux VPS Auto Setup | OgidaniLLC
set GITHUB_USER=OgidaniLLC
set REPO_NAME=linux-vps-portal
set SECRET_PREFIX=TRADING
echo ======================================================
echo    Linux VPS 爆速セットアップツール (Windows版)
echo ======================================================
echo.
set /p SERVER_IP="[1/3] VPSのIPアドレスを入力: "
set /p INPUT_KEY="[2/3] 今月の合言葉を入力: "
set YYYY=%date:~0,4%
set MM=%date:~5,2%
set CORRECT_KEY=%SECRET_PREFIX%%YYYY%%MM%
if not "%INPUT_KEY%"=="%CORRECT_KEY%" (
    echo [エラー] 合言葉が違います。
    pause
    exit
)
set /p VNC_PW="[3/3] 接続パスワード (空白なら vps12345): "
if "%VNC_PW%"=="" set VNC_PW=vps12345
echo 自動構築を開始します...
ssh root@%SERVER_IP% "sudo apt update && curl -fsSL https://get.docker.com | sh && mkdir -p trading-vps && cd trading-vps && curl -LO https://raw.githubusercontent.com/%GITHUB_USER%/%REPO_NAME%/main/docker-compose.yml && sed -i 's/VNC_PW=vps12345/VNC_PW=%VNC_PW%/g' docker-compose.yml && docker compose up -d"
echo 完了しました！
pause
