# MTAccountLabel（口座識別フローティングラベル）

**対象:** MTAccountLabel（MT5 / MT4 インジケーター）＋ 描画用DLL（MT5用 `MTFloatingLabel.dll` / MT4用 `MTFloatingLabel32.dll`）
**Version:** 1.00

> MT4/MT5のメインウィンドウ上に、クリック透過するフローティングラベルを表示し、複数口座を一目で識別できるインジケーターです。

---

## ダウンロード

[**こちらからダウンロード**](https://github.com/OgidaniLLC/linux-vps-portal/releases/tag/v-latest) → `MTAccountLabel.zip`

> 解凍には [7-Zip](https://www.7-zip.org/) とパスワードが必要です。

詳しい使い方は zip 同梱の `USER_MANUAL.md` を参照してください。

---

## 概要

複数のMT4/MT5を同時に起動する環境（特にVPS / RDP）では、どのウィンドウがどの口座か分からなくなりがちです。MTAccountLabel は、MTメインウィンドウ上に**任意のラベル（口座名・ブローカー名・口座番号など）を浮かべて表示**し、口座の取り違えを防ぎます。

## 主な特徴

- **チャート状態に依存しない**: タブ切替・シンボル変更・時間足変更でも表示が消えない・ズレない
- **クリック透過**: 通常時はラベルがマウス入力を背後のチャート・ポジション一覧・取引履歴・ツールバーへそのまま渡す
- **Ctrlドラッグで移動**: `Ctrl` 押下中だけラベルをドラッグ移動でき、離すとクリック透過へ戻る
- **座標を永続化**: 移動後の位置をMT再起動後も復元
- **MT4/MT5両対応**（表示ロジックを共通化。DLLはMT5用64bit・MT4用32bitを個別提供）
- **MT本体に非干渉**: タイトルや内部コントロールを一切変更しない

## 入力パラメータ（概要）

| パラメータ | 既定値 | 説明 |
|---|---|---|
| `LabelText` | `Label` | 表示文言（1〜128文字） |
| `TextColor` | 白 | 文字色 |
| `BackgroundColor` | DarkSlateGray | 背景パネルの色（`BackgroundOpacity` が `0` のときは表示されない） |
| `BackgroundOpacity` | `0` | 背景パネルの濃さ（数値 0=透明で文字のみ〜255=くっきり）。既定は透明 |
| `FontName` / `FontSize` | `Broadway` / `32` | フォント名・サイズ（8〜72） |
| `PositionX` / `PositionY` | `20` / `40` | メインウィンドウ基準の表示座標（各 0〜10000） |

詳細・操作方法・トラブルシューティングは `USER_MANUAL.md` を参照してください。

## 動作要件

- MT5 / MT4（build 600以降）
- インジケーター適用時に「**DLLの使用を許可**」を有効にすること

---

## ライセンス・免責

Copyright © 2026 OgidaniLLC. All rights reserved.
β版テスター募集フェーズにつきテスト期間中は無償。第三者への再配布・転売・リバースエンジニアリング等を禁止します。本ソフトウェアは「現状有姿」で提供され、使用に伴ういかなる損害についても責任を負いません。実取引でのご使用は十分に検証の上、自己責任でお願いします。

- 公式サイト: https://ogidani.com/ ／ note: https://note.com/fx_systradeea ／ X: https://x.com/FX_SysTradeEA
