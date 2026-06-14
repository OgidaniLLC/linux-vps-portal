# MTCommunityOutlook ユーザーマニュアル

**Version:** 1.12（2026-06-14）
**対象:** MTCommunityOutlook（MT5 / MT4 インジケーター）

---

## 1. 概要

MTCommunityOutlook は、Myfxbook の **Community Outlook**（各通貨ペアの Short/Long 比率＝市場参加者のセンチメント）をMTチャート上にコンパクト表示するインジケーターです。

- **自作DLL不要**（WinINet経由でMyfxbook公式APIを直接利用）
- **MT4 / MT5 両対応**
- Short/Long比率バー、相対人気度バーを表示
- Normal / Compact / Tiny の3サイズ
- ドラッグ移動・最小化・位置保存

---

## 2. 動作要件

- **MT5版**: MetaTrader 5 / **MT4版**: MetaTrader 4（build 600以降）
- インジケーター適用時に「**DLLの使用を許可**」を有効にすること（WinINet呼び出しのため）
- **Myfxbook アカウント**（メールアドレス＋パスワード）

> WebRequestのURL許可登録は不要です（本インジは MT5 の WebRequest ではなく WinINet を直接利用するため）。

---

## 3. インストール

### 配布物の構成

```
MTCommunityOutlook/
├── USER_MANUAL.md
├── MQL5/Indicators/
│   └── MTCommunityOutlook.ex5
└── MQL4/Indicators/
    └── MTCommunityOutlook.ex4
```

### 配置手順

MTのデータフォルダ（**ファイル → データフォルダを開く**）配下に配置します。

| 配布ファイル | 配置先（MT5 / MT4） |
|---|---|
| MTCommunityOutlook.ex5 / .ex4 | `MQL5(4)/Indicators/` |

### 起動

1. ナビゲータ → インジケーター → MTCommunityOutlook を任意のチャートにドラッグ
2. 「**DLLの使用を許可**」にチェック
3. `MyfxbookEmail` と `MyfxbookPassword` を入力して OK

---

## 4. 入力パラメータ

| パラメータ | 既定値 | 説明 |
|---|---|---|
| `DisplaySize` | SIZE_COMPACT | 表示サイズ（Normal / Compact / Tiny） |
| `Symbols` | "" | 表示する通貨ペアと順序を明示指定。空欄ならAPI取得全銘柄が対象 |
| `MaxSymbols` | 12 | 最大表示件数（初期値12・**上限128**。範囲外は自動補正） |
| `UsePercentageFilter` | true | Short/Longの片方が閾値超の銘柄だけ表示 |
| `PercentageThreshold` | 60.0 | 上記の閾値（%） |
| `UsePopularityFilter` | true | 取引参加が少ない銘柄を除外 |
| `MinimumRelativePopularity` | 10.0 | 最大totalPositionsに対する相対比率の下限（%） |
| `MyfxbookEmail` | "" | Myfxbookログインメール |
| `MyfxbookPassword` | "" | Myfxbookログインパスワード |
| `SaveCredentials` | true | 資格情報をCommon Filesに暗号化保存 |
| `ClearSavedCredentials` | false | trueで一度起動すると保存資格情報を削除 |
| `RefreshMinutes` | 30 | データ更新間隔（分） |
| `MaxCacheAgeHours` | 6 | これを超えた古いキャッシュは表示しない |
| `RequestTimeoutSeconds` | 5 | API要求タイムアウト |
| `PositionX` / `PositionY` | 10 / 30 | 表示位置 |
| `BackgroundColor` / `TextColor` | 紺 / 淡灰 | 背景色・文字色 |
| `ShortColor` / `LongColor` | 赤 / 緑 | Short/Longバーの色 |

---

## 5. 使い方のポイント

### 銘柄の絞り込み
- **`Symbols` 空欄**: API取得全銘柄が候補。`UsePercentageFilter=true` なら片側が `PercentageThreshold` 超の銘柄だけ、`totalPositions` 降順で `MaxSymbols` 件まで表示。
- **`Symbols` 明示指定**（例 `EURUSD,USDJPY,XAUUSD`）: **割合フィルター・人気度フィルターは一切適用されず**、指定した銘柄を指定順でそのまま表示します（閾値を超えていなくても表示）。つまり通貨を指定した時点でフィルター設定は無視されます。

### 表示の見方
- Short/Long バー：各通貨の売り/買い比率
- 下の細い青バー：相対人気度（API応答内の最大 totalPositions を100%とした比率）
- バーにホバーでツールチップ（銘柄・比率・ポジション数）

### 状態表示
- `Cached HH:MM - updating...`：キャッシュ表示中＋更新試行中
- `Updated HH:MM`：API取得成功
- `STALE`：更新失敗、古いデータを維持

### 資格情報
- ログイン成功時 `SaveCredentials=true` なら Common Files に **AES-256暗号化**して保存（保存した端末でのみ復号）。次回以降はメール/パスワード空欄で自動利用。
- 削除する場合は一度 `ClearSavedCredentials=true` で起動。
- 暗号鍵はCommon Filesの共通データパス基準で、MT4/MT5間で共有可能。

---

## 6. 注意事項

- 資格情報はインジケーターの入力値のため、**テンプレートや `.set` ファイルに保存される可能性**があります。共有時は注意してください（Common Filesの保存値はAES-256暗号化済み）。
- 本インジは Myfxbook公式API `get-community-outlook.json` のみ利用。Webスクレイピング・Cloudflare回避・非公開エンドポイントは使用しません。
- API応答に存在しない銘柄を `Symbols` に指定しても表示されません。
- API解析上限は512銘柄、画面表示は `MaxSymbols` 件まで（別管理）。
- `XAUUSD` 等の貴金属もAPIに含まれますが、フィルター条件を満たさなければ表示されません。

---

## 7. ライセンス・免責

Copyright © 2026 OgidaniLLC. All rights reserved.

β版テスター募集フェーズにつき、テスト期間中は無償でご利用いただけます（自己の取引環境での評価・検証目的に限る）。第三者への再配布・転売・譲渡、リバースエンジニアリング等を禁止します。本ソフトウェアは「現状有姿」で提供され、使用に伴ういかなる損害についても責任を負いません。実取引でのご使用は十分に検証の上、自己責任でお願いします。

- 公式サイト: https://ogidani.com/ ／ note: https://note.com/fx_systradeea ／ X: https://x.com/FX_SysTradeEA

---

## 8. 修正履歴

| バージョン | 日付 | 内容 |
|---|---|---|
| 1.12 | 2026-06-14 | session永続流用・取得間隔の最適化（連続アクセス抑制）・キャッシュ鮮度判定の不具合修正・ログをエラー系のみに整理 |
| 1.11 | 2026-06-12 | Community Outlook表示・3サイズ・人気度フィルター・資格情報V2暗号化・キャッシュ鮮度管理 |
