//+------------------------------------------------------------------+
//|                                              AddMiniChart.mq5    |
//|                                         Copyright 2026, OgidaniLLC. |
//|                                             https://www.ogidani.com |
//+------------------------------------------------------------------+
// 【概要】
//   現在のチャート左下にミニチャート（OBJ_CHART）を表示するインジケーター。
//   MT5専用。MT4では OBJ_CHART が非サポートのため動作しない。
//
// 【使い方】
//   1. AddMiniChart.mq5 と MiniChart.mqh を同じフォルダに置く
//   2. MetaEditorでコンパイル → MT5チャートに適用
//   3. パラメータでレイアウト・時間足・サイズを調整
//
// 【パラメータ】
//   InpLayout  : 1枚 / 縦2枚（デフォルト）/ 横2枚
//   InpPeriod1 : チャート1の時間足（デフォルト: H1）
//   InpPeriod2 : チャート2の時間足（デフォルト: H4）※2枚表示時のみ有効
//   InpWidth   : ミニチャートの幅（ピクセル）
//   InpHeight  : ミニチャートの高さ（ピクセル）
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, OgidaniLLC."
#property link      "https://www.ogidani.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_plots 0

#include "MiniChart.mqh"

// レイアウト選択肢
// LAYOUT_1  : ミニチャート1枚のみ表示
// LAYOUT_V2 : 縦に2枚並べて表示（デフォルト）
// LAYOUT_H2 : 横に2枚並べて表示
enum ENUM_LAYOUT {
    LAYOUT_1    = 1,  // 1枚
    LAYOUT_V2   = 2,  // 縦2枚
    LAYOUT_H2   = 3,  // 横2枚
};

input ENUM_LAYOUT      InpLayout    = LAYOUT_V2;    // レイアウト
input ENUM_TIMEFRAMES  InpPeriod1   = PERIOD_H1;    // チャート1 時間足
input ENUM_TIMEFRAMES  InpPeriod2   = PERIOD_H4;    // チャート2 時間足
input int              InpWidth     = 300;           // 幅（ピクセル）
input int              InpHeight    = 200;           // 高さ（ピクセル）

// ミニチャート管理オブジェクト（最大2枚）
CMiniChart g_chart;

//+------------------------------------------------------------------+
// OnInit: インジケーター初期化
//   - ミニチャートオブジェクトを作成して表示する
//   - 作成失敗時は INIT_FAILED を返してインジケーターを終了する
//+------------------------------------------------------------------+
int OnInit() {
    int num = (int)InpLayout;

    // ミニチャート作成（名前・幅・高さ・枚数を指定）
    if (!g_chart.Create("MiniChart", InpWidth, InpHeight, num)) {
        Print("CMiniChart Create failed");
        return INIT_FAILED;
    }

    // 時間足を設定（2枚目はレイアウトが2枚以上の場合のみ）
    g_chart.SetPeriod(InpPeriod1, 0);
    if (num > 1) g_chart.SetPeriod(InpPeriod2, 1);

    g_chart.Show();
    ChartRedraw();
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
// OnDeinit: インジケーター終了
//   - CMiniChart のデストラクタが自動的にオブジェクトを削除する
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
}

//+------------------------------------------------------------------+
// OnCalculate: ティック毎の処理
//   - ミニチャートはOBJ_CHARTオブジェクトが自律的に更新するため
//     ここでは何もしない
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[], const double &open[],
                const double &high[], const double &low[],
                const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[]) {
    return rates_total;
}
