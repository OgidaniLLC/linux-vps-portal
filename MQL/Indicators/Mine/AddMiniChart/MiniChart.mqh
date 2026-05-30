//+------------------------------------------------------------------+
//|                                                   MiniChart.mqh  |
//|                                         Copyright 2025, OgidaniLLC. |
//|                                             https://www.ogidani.com |
//+------------------------------------------------------------------+
// 【概要】
//   MT5チャート上にミニチャート（OBJ_CHART）を表示するクラス CMiniChart。
//   OBJ_CHART はMT5専用オブジェクト。MT4では使用不可。
//
// 【使い方】
//   CMiniChart chart;
//   chart.Create("MiniName", 300, 200, 2);  // 名前・幅・高さ・枚数
//   chart.SetPeriod(PERIOD_H1, 0);          // 1枚目の時間足
//   chart.SetPeriod(PERIOD_H4, 1);          // 2枚目の時間足
//   chart.Show();
//
// 【レイアウト（Num引数）】
//   Num=1 : 1枚のみ（左下コーナーに配置）
//   Num=2 : 縦2枚（下から上へ積み上げ）
//   Num=3 : 横2枚（左から右へ並べ）
//+------------------------------------------------------------------+

class CMiniChart {
private:
    string m_name[2];   // OBJ_CHARTオブジェクト名（[0]=1枚目, [1]=2枚目）
    int    m_x;         // 幅（ピクセル）
    int    m_y;         // 高さ（ピクセル）
    int    m_num;       // 表示枚数（1:1枚, 2:縦2枚, 3:横2枚）

    //+------------------------------------------------------------------+
    // SetTimeFrameAuto: 現在時間足から相対的な時間足を返す
    //   eTimeFrame : 基準となる時間足
    //   Upper      : オフセット（+1で1段上, +2で2段上, -1で1段下）
    //   例）H1チャートでUpper=1 → H4を返す
    //+------------------------------------------------------------------+
    ENUM_TIMEFRAMES SetTimeFrameAuto(ENUM_TIMEFRAMES eTimeFrame, int Upper)
    {
        ENUM_TIMEFRAMES eResult = PERIOD_CURRENT;

        // サポートする時間足を昇順で定義
        ENUM_TIMEFRAMES eTF[] = {
            PERIOD_M1,
            PERIOD_M5,
            PERIOD_M15,
            PERIOD_M30,
            PERIOD_H1,
            PERIOD_H4,
            PERIOD_D1,
            PERIOD_W1,
            PERIOD_MN1
        };

        for (int iIndex = 0; iIndex < ArraySize(eTF) && iIndex + 1 < ArraySize(eTF); iIndex++) {
            if ((eTF[iIndex] < eTimeFrame && eTimeFrame < eTF[iIndex + 1]) || eTimeFrame == eTF[iIndex]) {
                if (iIndex + Upper < 0) {
                    // 下限を超えたら最小時間足を返す
                    eResult = eTF[0];
                } else if (iIndex + Upper >= ArraySize(eTF)) {
                    // 上限を超えたら最大時間足を返す
                    eResult = eTF[ArraySize(eTF) - 1];
                } else {
                    eResult = eTF[iIndex + Upper];
                }
                break;
            }
        }
        return eResult;
    }

public:
    CMiniChart() {}

    // デストラクタ: チャートオブジェクトを自動削除
    ~CMiniChart() {
        ObjectDelete(0, m_name[0]);
        ObjectDelete(0, m_name[1]);
    }

    //+------------------------------------------------------------------+
    // Create: ミニチャートを作成してサイズ・時間足を初期設定する
    //   strName : オブジェクト名（重複しないようにすること）
    //   X       : 幅（ピクセル）
    //   Y       : 高さ（ピクセル）
    //   Num     : 表示枚数（1/2/3）
    //   戻り値  : 作成成功=true, 失敗=false
    //+------------------------------------------------------------------+
    bool Create(string strName, int X, int Y, int Num = 1) {
        m_name[0] = strName;
        m_x = X;
        m_y = Y;
        ChartNum(Num);

        // 1枚目を作成
        bool bResult = Create(m_name[0]);

        // 2枚目を作成（Num > 1 の場合のみ）
        m_name[1] = strName + "2";
        if (1 < Num) bResult &= Create(m_name[1]);

        if (bResult) {
            Size(m_x, m_y);
            // デフォルトで現在時間足の1段上を設定
            SetPeriod(SetTimeFrameAuto((ENUM_TIMEFRAMES)Period(), 1));
            Scale();
        } else {
            ObjectDelete(0, m_name[0]);
        }
        return bResult;
    }

    //+------------------------------------------------------------------+
    // Create: OBJ_CHARTオブジェクトを1個作成して基本プロパティを設定する
    //   Name    : オブジェクト名
    //   戻り値  : 作成成功=true, 失敗=false
    //+------------------------------------------------------------------+
    bool Create(string Name) {
        bool bResult = ObjectCreate(0, Name, OBJ_CHART, 0, 0, 0);
        if (bResult) {
            ::ObjectSetInteger(0, Name, OBJPROP_COLOR,       clrWhite);          // ローソク足色
            ::ObjectSetInteger(0, Name, OBJPROP_BGCOLOR,     clrBlack);          // 背景色
            ::ObjectSetInteger(0, Name, OBJPROP_CORNER,      CORNER_LEFT_LOWER); // 左下コーナー基準
            ::ObjectSetInteger(0, Name, OBJPROP_FONTSIZE,    8);
            ::ObjectSetInteger(0, Name, OBJPROP_SELECTABLE,  0);                 // クリック選択不可
            ::ObjectSetInteger(0, Name, OBJPROP_DATE_SCALE,  false);             // 時間軸非表示
            ::ObjectSetInteger(0, Name, OBJPROP_PRICE_SCALE, false);             // 価格軸非表示
            ::ObjectSetString (0, Name, OBJPROP_FONT,        "Arial");
            ::ObjectSetString (0, Name, OBJPROP_TEXT,        _Symbol);           // 現在銘柄を表示
        }
        return bResult;
    }

    // 内部用: インデックス指定でプロパティを設定する（iIndex=0:1枚目, 1:2枚目）
    bool ObjectSetInteger(ENUM_OBJECT_PROPERTY_INTEGER Prop, long Value, int iIndex = 0) {
        if (0 == iIndex) return ::ObjectSetInteger(0, m_name[0], Prop, Value);
        return ::ObjectSetInteger(0, m_name[1], Prop, Value);
    }

    // 時間足を直接指定して設定する（iIndex=0:1枚目, 1:2枚目）
    void SetPeriod(ENUM_TIMEFRAMES Period, int iIndex = 0) { ObjectSetInteger(OBJPROP_PERIOD, Period, iIndex); }

    // 現在時間足からの相対オフセットで時間足を設定する（Upper=+1で1段上）
    void SetPeriod(int Upper, int iIndex = 0) { SetPeriod(SetTimeFrameAuto((ENUM_TIMEFRAMES)Period(), Upper), iIndex); }

    //+------------------------------------------------------------------+
    // Scale: 現在チャートのスケールより1段小さいスケールをミニチャートに設定
    //   ミニチャートが小さく見えるよう自動調整する
    //+------------------------------------------------------------------+
    void Scale() {
        long iScale = ChartGetInteger(0, CHART_SCALE);
        iScale--;
        if (0 > iScale) iScale = 0;
        ObjectSetInteger(OBJPROP_CHART_SCALE, iScale, 0);
        if (1 < m_num) ObjectSetInteger(OBJPROP_CHART_SCALE, iScale, 1);
    }

    //+------------------------------------------------------------------+
    // Size: ミニチャートのサイズと表示位置を設定する
    //   Width  : 幅（ピクセル）
    //   Height : 高さ（ピクセル）
    //   配置基準は CORNER_LEFT_LOWER（左下コーナー）
    //   縦2枚(Num=2): 下から上へ積み上げ
    //   横2枚(Num=3): 左から右へ並べ
    //+------------------------------------------------------------------+
    void Size(int Width, int Height) {
        // 1枚目のサイズと位置
        ObjectSetInteger(OBJPROP_XSIZE,     Width);
        ObjectSetInteger(OBJPROP_YSIZE,     Height);
        ObjectSetInteger(OBJPROP_XSIZE,     Width,  1);
        ObjectSetInteger(OBJPROP_YSIZE,     Height, 1);
        ObjectSetInteger(OBJPROP_XDISTANCE, 0);
        ObjectSetInteger(OBJPROP_YDISTANCE, Height);        // 左下から Height 上

        if (2 == m_num) {
            // 縦2枚: 2枚目を1枚目のさらに上に配置
            ObjectSetInteger(OBJPROP_XDISTANCE, 0,          1);
            ObjectSetInteger(OBJPROP_YDISTANCE, Height * 2, 1);
        } else if (3 == m_num) {
            // 横2枚: 2枚目を1枚目の右に配置
            ObjectSetInteger(OBJPROP_XDISTANCE, Width,  1);
            ObjectSetInteger(OBJPROP_YDISTANCE, Height, 1);
        }
    }

    // 表示枚数を設定する（Create前に呼ぶこと）
    void ChartNum(int Num) { m_num = Num; }

    // ミニチャートを全時間足で表示する
    void Show() {
        ObjectSetInteger(OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        if (1 < m_num) ObjectSetInteger(OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS, 1);
    }

    // ミニチャートを全時間足で非表示にする
    void Hide() {
        ObjectSetInteger(OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if (1 < m_num) ObjectSetInteger(OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS, 1);
    }
};
