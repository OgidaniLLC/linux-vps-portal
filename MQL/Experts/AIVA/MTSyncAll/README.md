# MTSyncAll コピートレード

**対象:** MTS_CopyMaster / MTS_CopySlave（EA v1.05）・MTS_CopyMonitor（インジケーター v1.01）
**プラットフォーム:** MT5 / MT4

> 超低遅延でMT5/MT4間のポジションをコピーするEAシステム＋稼働状況モニター。

---

## ダウンロード

[**こちらからダウンロード**](https://github.com/OgidaniLLC/linux-vps-portal/releases/tag/v-latest) → `MTSyncAll-CopyTrade.zip`

> 解凍には [7-Zip](https://www.7-zip.org/) とパスワード（**今月の合言葉**）が必要です。
> 合言葉はメンバー向けに別途ご案内しています。

詳しい使い方は zip 同梱のマニュアルを参照してください。

- `USER_MANUAL.md` … 本体（CopyMaster / CopySlave）の操作・パラメータ・トラブルシューティング
- `MONITOR_MANUAL.md` … モニター（CopyMonitor）の操作・画面の見方

---

## 1. 概要

MTSyncAll コピートレードは、超低遅延でMT5/MT4間のポジションをコピーするEAシステムです。

- **マスターEA（MTS_CopyMaster）**: ポジションのopen/close/modifyを検知して配信
- **スレーブEA（MTS_CopySlave）**: 受信して同じ操作を自分の口座で実行
- **モニター（MTS_CopyMonitor）**: スレーブ側のコピー状況（成功/スキップ/失敗/未処理）を可視化するインジケーター

### 主な特徴

- **超低遅延**: イベント駆動通知でマスターからスレーブへ即時配信（closeキュー方式により一括決済も20〜50ms）
- **3通信モード**: 同一PC（共有メモリ）/ 他PC（TCP）/ 両方（同時配信）
- **複数マスター対応**（上限13台）
- **複数スレーブ対応**: 1マスターに複数スレーブ接続可能（1対多）
  - ※ 1スレーブが複数マスターを同時購読することは不可（多対多運用不可）
- **プラットフォーム自由組合せ**: MT5↔MT5 / MT4↔MT4 / MT5↔MT4 / MT4↔MT5 すべて対応
- **部分決済対応**: マスターの部分決済を割合（lot_pct）でスレーブにも反映
- **ロット指定方式**: 倍率 / 固定ロットを選択可能
- **冪等性保証**: 二重発注なし
- **自動クリーンアップ**: マスター不在ポジションを自動決済（HBで同期）
- **フェイルセーフ**: 鮮度・スプレッド・価格乖離・HBタイムアウトの4重ガード
- **コピー状況の可視化**: MTS_CopyMonitor で各ポジションの copied / skipped / failed / pending を一覧表示

---

## 2. 配布物の構成

```
MTSyncAll-CopyTrade/
├── USER_MANUAL.md                     本体マニュアル（CopyMaster / CopySlave）
├── MONITOR_MANUAL.md                  モニターマニュアル（CopyMonitor）
├── MQL5/
│   ├── Experts/MTSyncAll/
│   │   ├── MTS_CopyMaster.ex5
│   │   └── MTS_CopySlave.ex5
│   ├── Indicators/MTSyncAll/
│   │   └── MTS_CopyMonitor.ex5
│   └── Libraries/
│       └── MTSyncAll.dll              ← MT5用（64bit）
└── MQL4/
    ├── Experts/MTSyncAll/
    │   ├── MTS_CopyMaster.ex4
    │   └── MTS_CopySlave.ex4
    ├── Indicators/MTSyncAll/
    │   └── MTS_CopyMonitor.ex4
    └── Libraries/
        └── MTSyncAll32.dll            ← MT4用（32bit、ファイル名で識別）
```

### 配置のしかた

MT5/MT4のデータフォルダ（**ファイル → データフォルダを開く**）配下に、zip内 `MQL5/` `MQL4/` の各ファイルを**同じ階層へそのままコピー**します（リネーム不要）。

| 配布ファイル | 配置先（MT5 / MT4） |
|---|---|
| Libraries の DLL | `MQL5/Libraries/` ・ `MQL4/Libraries/` |
| MTS_CopyMaster | `MQL5/Experts/MTSyncAll/` ・ `MQL4/Experts/MTSyncAll/` |
| MTS_CopySlave | `MQL5/Experts/MTSyncAll/` ・ `MQL4/Experts/MTSyncAll/` |
| MTS_CopyMonitor | `MQL5/Indicators/MTSyncAll/` ・ `MQL4/Indicators/MTSyncAll/` |

> ✅ MT5用は `MTSyncAll.dll`、MT4用は `MTSyncAll32.dll` とファイル名で識別済み。
> MT5/MT4が同じデータフォルダを共有する構成でも安全に共存できます。

---

## 3. MTS_CopyMonitor（コピー状況モニター）

スレーブ側のコピー状況をリアルタイムに可視化するインジケーターです。

- マスター保有ポジション一覧と、各ポジションの **copied / skipped / failed / pending** を表示
- HB途絶やマスター/スレーブ件数の不一致を**色で警告**
- 通貨タブで絞り込み、複数スレーブ（magic）の切替に対応

> スレーブEAが稼働していれば、**完全に独立した別チャート**に載せて動作します。
> 画面の見方・各ステータスの意味は `MONITOR_MANUAL.md` を参照してください。

---

## 4. 動作要件・通信モード（概要）

- **MT5版**: MetaTrader 5 / **MT4版**: MetaTrader 4（build 600以降）
- 通信モードは「同一PC（共有メモリ）」「他PC（TCP）」「両方（同時配信）」の3種
  - ネットワーク設定に不慣れな方は **同一PC（共有メモリ）モード** を推奨

> 各モードの設定手順・パラメータ詳細・銘柄別推奨値・トラブルシューティングは
> 同梱の `USER_MANUAL.md` に記載しています。

---

## 5. 利用条件・期限について

- 本ソフトウェアは **β版テスター募集フェーズ**にあり、テスト期間中は**無償**でご利用いただけます。
- **スレーブEAにはビルド日時から90日間の利用期限**があります。期限切れのスレーブEAは起動しないため、その場合は最新版に差し替えてください（モニターにも何も表示されなくなります）。

---

## 6. ライセンス・免責

Copyright © 2026 OgidaniLLC. All rights reserved.

- 第三者への再配布・転売・譲渡、リバースエンジニアリング等を禁止します。
- 本ソフトウェアは「現状有姿」で提供され、使用に伴ういかなる損害についても責任を負いません。**実取引でのご使用は十分に検証の上、自己責任でお願いします。**

### 連絡先・公式サイト

- 公式サイト: https://ogidani.com/
- note: https://note.com/fx_systradeea
- X(Twitter): https://x.com/FX_SysTradeEA

---

## 7. 修正履歴

### 本体（MTS_CopyMaster / MTS_CopySlave）

| バージョン | 日付 | 内容 |
|---|---|---|
| v1.05 | 2026-06-04 | closeキューをラウンドロビンバッファ化（一括決済遅延を改善）。スレーブに利用期限（ビルド日時+90日）を追加 |
| v1.05 | 2026-06-02 | スレーブに `ロット指定方式`（倍率 / 固定ロット）と `固定ロット` を追加 |
| v1.04 | 2026-05-22 | スレーブに `最小有利価格差` を追加（スキャル用途のペンディング対応） |
| v1.03 | 2026-05-22 | `価格乖離ガードを使う` 追加・リトライタイムアウト無効化対応ほか |
| v1.02 | 2026-05-14 | `InpMasterSuffix` 追加・非FXシンボル対応・ペンディングキュー実装 |
| v1.01 | 2026-05-12 | `配信対象magic` デフォルトを 0 に修正・リリースビルド対応 |
| v1.00 | 2026-05-09 | 初版リリース |

### モニター（MTS_CopyMonitor）

| バージョン | 日付 | 内容 |
|---|---|---|
| v1.01 | 2026-06-04 | GUIをEasyAndFastGUIに移行・テーブル再描画最適化・パラメータ整理 |
| v1.00 | 2026-05-12 | 初版リリース |
