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

### MT4/MT5が文字化けする
**原因:** Wine内に日本語フォントがない。
**対処:** setup_vps.bat を再実行するか、ローカルのコマンドプロンプトで以下を実行。
```
scp "C:\Windows\Fonts\msgothic.ttc" root@[VPSのIP]:/tmp/
ssh root@[VPSのIP] "docker cp /tmp/msgothic.ttc trading-vps:/root/.wine/drive_c/windows/Fonts/"
```

任意のフォントを追加したい場合は、`C:\Windows\Fonts\` 内の `.ttf` または `.ttc` ファイルを同様の手順で転送できます。
```
scp "C:\Windows\Fonts\[フォントファイル名]" root@[VPSのIP]:/tmp/
ssh root@[VPSのIP] "docker cp /tmp/[フォントファイル名] trading-vps:/root/.wine/drive_c/windows/Fonts/"
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

### デフォルトブラウザが開かない
**原因:** XFCEのタスクバーランチャーにブラウザが設定されていない。
**対処:** SSHで以下を実行。
```
ssh root@[VPSのIP] "docker exec trading-vps bash -c 'sed -i \"s|Exec=exo-open --launch WebBrowser|Exec=chromium --no-sandbox|g\" /root/.config/xfce4/panel/launcher-*/*.desktop' && docker restart trading-vps"
```

---

### デスクトップにHelpショートカットがない
**原因:** コンテナの再起動でショートカットが生成されていない。
**対処:** コンテナを再起動する。
```
ssh root@[VPSのIP] "cd ~/trading-vps && docker compose restart"
```

---

## Claude.ai に相談する方法

エラーが発生したときだけでなく、**最初からClaudeに頼む**こともできます。
リポジトリのコードや構成を参照しながら、状況に合わせた対処法を自動で考えてくれます。

**こんな使い方がおすすめ：**
- エラーが出て対処法がわからないとき
- 最初から一緒に進めたいとき（「このリポジトリを使ってVPSを構築したい」と伝えるだけでOK）
- カスタマイズしたいとき（フォント追加、MT5の設定など）

**より高度なサポートを受けたい方（経験者向け）：**
VSCode + [Claude Code拡張](https://marketplace.visualstudio.com/items?itemName=Anthropic.claude-code) を使うと、Claudeがターミナル操作やファイル編集を直接行いながらサポートできます。エラーの診断からコマンド実行まで一貫して任せることができます。

---

**プランについて：**
無料版は使用制限があるため、以下のいずれかを推奨します。
- **Proプラン**: 月$20固定（気軽に使いたい方向け）
- **API従量制**: $5からチャージ式（セットアップ相談程度なら$5で十分）

**使い方：**
1. [Claude.ai](https://claude.ai) を開く
2. `setup_vps.bat` をチャットに添付する（Claudeがコードを参照して的確に対応できます）
3. 以下のように貼り付ける

```
linux-vps-portal を使ってVPSをセットアップしたいです。
リポジトリ: https://github.com/OgidaniLLC/linux-vps-portal

[状況やエラー内容があれば記載]
```

---

© 2026 OgidaniLLC
