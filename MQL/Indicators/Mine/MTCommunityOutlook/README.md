# MTCommunityOutlook（Myfxbook センチメント表示）

**対象:** MTCommunityOutlook（MT5 / MT4 インジケーター）
**Version:** 1.11

> Myfxbook の Community Outlook（各通貨ペアの Short/Long 比率）をMTチャート上にコンパクト表示するインジケーターです。自作DLL不要。

---

## ダウンロード

[**こちらからダウンロード**](https://github.com/OgidaniLLC/linux-vps-portal/releases/tag/v-latest) → `MTCommunityOutlook.zip`

> 解凍には [7-Zip](https://www.7-zip.org/) とパスワードが必要です。

詳しい使い方は [USER_MANUAL.md](./USER_MANUAL.md) を参照してください。

---

## 概要

Myfxbook の Community Outlook データ（市場参加者の売り/買いセンチメント）を、チャートから離れずに確認できます。

## 主な特徴

- **自作DLL不要**（WinINetでMyfxbook公式APIを直接利用）
- **MT4 / MT5 両対応**
- Short / Long 比率バー ＋ 相対人気度バー
- **Normal / Compact / Tiny** の3表示サイズ
- 通貨ペアの表示候補・順序を指定可能（`Symbols`）。空欄ならAPI全銘柄に閾値/人気度フィルタを適用、指定時はフィルタ無視で指定銘柄をそのまま表示
- 取引参加が少ない銘柄を除外する人気度フィルター
- ドラッグ移動・最小化・位置保存
- 資格情報を Common Files に **AES-256暗号化**保存（保存端末でのみ復号、MT4/MT5共有）
- キャッシュ鮮度管理（Updated / Cached…updating / STALE）

## 動作要件

- MT5 / MT4（build 600以降）、Myfxbook アカウント
- インジケーター適用時に「**DLLの使用を許可**」を有効化

## 入力（主なもの）

`DisplaySize` / `Symbols` / `MaxSymbols` / `PercentageThreshold` / `MinimumRelativePopularity` / `MyfxbookEmail` / `MyfxbookPassword` / `RefreshMinutes` ほか。詳細は `USER_MANUAL.md`。

---

## データについて

Myfxbook公式API `get-community-outlook.json` のみを利用します。Webスクレイピング・Cloudflare回避・非公開エンドポイントは使用しません。

## ライセンス・免責

Copyright © 2026 OgidaniLLC. All rights reserved.
第三者への再配布・転売・リバースエンジニアリング等を禁止します。本ソフトウェアは「現状有姿」で提供され、使用に伴ういかなる損害についても責任を負いません。実取引でのご使用は十分に検証の上、自己責任でお願いします。

- 公式サイト: https://ogidani.com/ ／ note: https://note.com/fx_systradeea ／ X: https://x.com/FX_SysTradeEA
