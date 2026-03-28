# 🚀 Trading VPS Portal (Linux専用)

Dockerを使用した、トレーディング専用のLinux(Ubuntu)デスクトップ環境です。
1行のコマンド、または専用ツール（バッチファイル）を使うだけで、プロ仕様の24時間稼働サーバーを構築できます。

---

## ✨ 主な特徴

* **爆速セットアップ**
  Dockerの導入から実行環境の構築まで、全自動で完結します。

* **ブラウザから操作可能**
  専用ソフト（RDP等）は不要です。Chromeなどのブラウザから、いつでもどこでもチャートを確認できます。

* **軽量・高安定**
  自動売買に特化した最小構成のため、低スペックなVPSでも安定して動作します。

---

## 📋 メンバー専用ポータル

メンバーの方は、専用ポータルから「自分専用のセットアップコマンド」を発行できます。
識別IDが含まれるため、セキュリティを維持したまま導入が可能です。

🔗 [**メンバー専用ポータルサイトを開く**](https://OgidaniLLC.github.io/linux-vps-portal/)

---

## 🛠️ 導入方法（選べる2パターン）

### パターンA：Windows専用セットアップツール（初心者向け）
「黒い画面の操作が苦手」という方向けの、ダブルクリックで完結する方法です。

1. 本リポジトリにある setup_vps.bat をダウンロードします。
2. ファイルを右クリックして「管理者として実行」します。
3. 画面の指示に従って「サーバーIP」と「今月の合言葉」を入力するだけで構築が完了します。

### パターンB：クイックスタート（手動導入）
サーバーにSSHログイン後、以下の1行コマンドを貼り付けてください。

`ash
sudo apt update && curl -fsSL [https://get.docker.com](https://get.docker.com) | sh && mkdir -p trading-vps && cd trading-vps && curl -LO [https://raw.githubusercontent.com/OgidaniLLC/linux-vps-portal/main/docker-compose.yml](https://raw.githubusercontent.com/OgidaniLLC/linux-vps-portal/main/docker-compose.yml) && docker compose up -d
`

---

## 🔐 ログイン・接続方法

本システムには「2種類」のログインがあります。

### 1. サーバー管理用 (SSH)
セットアップ時やメンテナンス時に使用します。
* **ツール**: Windowsターミナル、PowerShell、TeraTermなど
* **コマンド**: ssh root@[あなたのサーバーIP]
* **パスワード**: VPS契約時に設定したOSのパスワード

### 2. トレード操作用 (ブラウザVNC)
日常のチャート監視やEA設定に使用します。
* **URL**: http://[あなたのサーバーIP]:6080/vnc.html
* **操作**: 画面中央の「Connect」ボタンをクリック
* **初期パスワード**: vps12345

---

## 🛡️ ライセンス・免責事項
本プログラムの利用に関連して生じた損害について、開発者は一切の責任を負いません。投資は必ず自己責任で行ってください。

© 2026 **OgidaniLLC** | Professional Trading Solutions.
