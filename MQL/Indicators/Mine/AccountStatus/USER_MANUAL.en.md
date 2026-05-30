# AccountStatus User Manual

**Version:** 1.0 (2026-05-31)
**Target:** AccountStatus.mq5 / AccountStatus.mq4 (MT5 / MT4)

---

## 1. Overview

AccountStatus is an indicator that displays account balance history as a graph in a sub-window.

It visualizes balance, free margin, and maximum balance over time based on past trade history. You can hover over the graph to check drawdown and balance at any point in time.

### Key Features

- **Balance History Graph**: Displays balance changes as a line based on past trade history
- **Max Balance Line**: Shows the historical maximum balance
- **Margin Free Line**: Shows free margin history
- **Mouseover Popup**: Displays balance, max DD, and P&L at the cursor position
- **Scale Range Control**: Zoom into a specific range by setting upper/lower limits in %
- **Legend Toggle**: Press the ＋ button at the bottom-left to show/hide the legend
- **Supports both MT5 and MT4**

---

## 2. Installation

### File Placement

### File Structure

```
AccountStatus/
├── AccountStatus.ex5        ← For MT5 (Japanese)
├── AccountStatus.ex4        ← For MT4 (Japanese)
├── AccountStatus(EN).ex5    ← For MT5 (English)
├── AccountStatus(EN).ex4    ← For MT4 (English)
├── USER_MANUAL.md           ← User manual (Japanese)
└── USER_MANUAL.en.md        ← User manual (English)
```

### File Placement

**MT5:** Place in `MQL5/Indicators/` inside the MT5 data folder.

**MT4:** Place in `MQL4/Indicators/` inside the MT4 data folder.

> The data folder can be found via **File → Open Data Folder** in MT5/MT4.

### Applying to a Chart

Find `AccountStatus` in the Navigator (Ctrl+N) and drag it onto a chart. It will appear in a sub-window.

---

## 3. Display Lines

The graph shows the following 3 lines:

| Line | Color (Default) | Description |
|---|---|---|
| **Balance** | Blue (DodgerBlue) | Estimated account balance at each point. Reconstructed by accumulating past trade P&L |
| **Margin Free** | Red (Red) | Free margin while holding positions. **Only recorded on real-time tick updates** — bars before the indicator was applied will be empty |
| **Max Balance** | Yellow (Yellow) | The highest balance up to that point. Always equal to or above the Balance line |

---

## 4. Terminology

| Term | Description |
|---|---|
| **Balance** | Cash balance of the account. Does not include unrealized P&L of open positions |
| **Margin Free** | Funds available for new orders. Balance − Used Margin |
| **Max Balance** | The highest balance value recorded from the past to the present |
| **Drawdown (DD)** | Decline from the maximum balance. Calculated as: Max Balance − Current Balance. If the current balance exceeds the historical maximum (e.g. due to unrealized profit), the value will be negative |
| **Max DD%** | Drawdown expressed as a percentage of Max Balance. DD ÷ Max Balance × 100. A negative value means the current balance is at a new all-time high |
| **Credit** | Bonus funds granted by the broker. Can be included in or excluded from balance via parameter |

---

## 5. Parameters

| Parameter | Default | Description |
|---|---|---|
| **Balance** | ON | Show/hide the Balance line (Blue / DodgerBlue) |
| - Color | Blue (DodgerBlue) | Balance line color (MT4 only) |
| - Label | Amount | Label format at right edge of graph (None / Name+Amount / Name / Amount) |
| **Margin Free** | ON | Show/hide the Margin Free line (Red). Only recorded on real-time tick updates |
| - Color | Red | Margin Free line color (MT4 only) |
| - Label | Amount | Label format at right edge of graph |
| **Max Balance** | ON | Show/hide the Max Balance line (Yellow) |
| - Color | Yellow | Max Balance line color (MT4 only) |
| - Label | Amount | Label format at right edge of graph |
| **Info Font Size** | Large (16) | Font size for mouseover popup (Small=10 / Large=16) |
| **Add Credit to Balance** | ON | Include broker bonus credit in balance calculation |
| **Scale Top (%)** | 101 | Upper display limit as % of value range. Values above 100 add margin above the max |
| **Scale Bottom (%)** | 0 | Lower display limit as % of value range. Set to 95 to show only the top 5% |

### Scale Setting Examples

The display range is specified as a percentage of the total value range (Max − Min = 100%).

| Setting | Top | Bottom | Effect |
|---|---|---|---|
| Full range (default) | 101 | 0 | Full range + 1% margin above |
| Top 5% only | 101 | 95 | Zooms in near the maximum value |
| Bottom 10% only | 10 | 0 | Zooms in near the minimum value |
| Middle range | 60 | 40 | Zooms in on the middle of the range |

> **When unrealized P&L is large**: Open positions with large floating profit/loss may cause the graph to spike temporarily. Setting the top to 105–110 can help keep the graph visible.

---

## 6. How to Use

### Showing the Legend

Press the **＋ button** at the bottom-left of the sub-window to show the legend. Press again to hide it.

### Mouseover Popup

Move the mouse cursor over the graph to display bar information in a popup after approximately 0.1 seconds.

| Item | Description |
|---|---|
| **Time** | The time of that bar |
| **Max DD** | Maximum drawdown from the peak balance at that point (amount & %) |
| **Balance** | Estimated balance at that point |
| **Max P&L** | The maximum P&L recorded within that bar (minimum value of floating P&L) |

The popup disappears automatically approximately 3 seconds after the cursor stops moving.

> **Note**: The popup only works within the sub-window. It will not appear when hovering over the main chart.

---

## 7. Notes

- **Past balance is an estimate.** It is calculated by working backwards from the current balance using past trade P&L. Deposits and withdrawals are not reflected.
- In MT4, results depend on the number of bars loaded in the chart. If few bars are loaded, older trade history will be accumulated in the oldest bar.
- **The Margin Free line (red) is only recorded on real-time tick updates.** It will not appear for bars before the indicator was applied. To extend the line, keep the indicator applied continuously.
- **In MT5, line colors are fixed in code** (DodgerBlue / Red / Yellow). To change them, modify the source code.

---

## 8. Requirements

- MetaTrader 5
- MetaTrader 4

---

## 9. License

Copyright © 2026 OgidaniLLC. All rights reserved.

This software is distributed to members only. Redistribution or resale to third parties is prohibited.
