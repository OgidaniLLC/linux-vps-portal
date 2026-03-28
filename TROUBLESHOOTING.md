# 🛠️ トラブルシューティング

セットアップ中に問題が発生した場合は、以下を参照してください。
解決しない場合は、エラーメッセージをそのままコピーして **Claude.ai** に貼り付けてください。

---

## よくある問題

### setup_vps.bat を実行してもすぐ閉じる
**原因:** 文字化けまたはエラーで終了している。
**対処:** コマンドプロンプトから実行してエラーを確認する。
```
cmd /c setup_vps.bat
```

---

### SSH接続時に「REMOTE HOST IDENTIFICATION HAS CHANGED」と表示される
**原因:** VPSを再インストールするとホストキーが変わる。
**対処:** 古いキーを削除する。
```
ssh-keygen -R [VPSのIPアドレス]
```

---

### VNC接続できない（画面が真っ黒 / 接続拒否）
**原因:** コンテナが起動していない可能性がある。
**対処:** コンテナを再起動する。
```
ssh root@[VPSのIP] "cd ~/trading-vps && docker compose restart"
```

---

### MT5が文字化けする
**原因:** Wine内に日本語フォントがない。
**対処:** setup_vps.bat を再実行するか、ローカルのコマンドプロンプトで以下を実行。
```
scp "C:\Windows\Fonts\msgothic.ttc" root@[VPSのIP]:/tmp/
ssh root@[VPSのIP] "docker cp /tmp/msgothic.ttc trading-vps:/root/.wine/drive_c/windows/Fonts/"
```

---

### デスクトップにMT5のショートカットがない
**原因:** MT5インストール後にコンテナを再起動していない。
**対処:** MT5インストール完了後にコンテナを再起動する。
```
ssh root@[VPSのIP] "cd ~/trading-vps && docker compose restart"
```

---

### VNCパスワードを忘れた / 変更したい
**対処:** `change_vnc_pw.bat` を使用する。
または以下のコマンドで変更（新パスワードは英数字のみ推奨）。
```
ssh root@[VPSのIP] "docker exec trading-vps bash -c 'echo 新パスワード | vncpasswd -f > /root/.vnc/passwd' && docker restart trading-vps"
```

---

## Claude.ai に相談する方法

1. エラーメッセージをコピー
2. Claude.ai を開く
3. 以下のように貼り付ける

```
linux-vps-portal のセットアップ中に以下のエラーが発生しました。
リポジトリ: https://github.com/OgidaniLLC/linux-vps-portal

エラー内容:
[ここにエラーメッセージを貼り付け]

どう対処すればよいですか？
```

---

© 2026 OgidaniLLC
