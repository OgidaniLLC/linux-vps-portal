# AccountStatus

An indicator that displays account balance history as a graph in a sub-window of MT5/MT4.

[日本語](README.md)

## Download

[**Download here**](https://github.com/OgidaniLLC/linux-vps-portal/releases/tag/v-latest) → `AccountStatus.zip`

> [7-Zip](https://www.7-zip.org/) and a password are required to extract.

---

## Features

- Displays balance history, maximum balance, and free margin as lines based on past trade history
- Shows balance, max drawdown, and P&L in a popup when hovering over the graph
- Toggle legend display with the ＋ button at the bottom-left
- Supports both MT5 and MT4

## Display Lines

| Line | Color (Default) | Description |
|---|---|---|
| **Balance** | Blue (DodgerBlue) | Estimated account balance at each point in time |
| **Margin Free** | Red | Free margin while holding positions. **Only recorded on real-time tick updates** — past bars before the indicator was applied will be empty |
| **Max Balance** | Yellow | The highest balance recorded up to that point in time |

## Terminology

| Term | Description |
|---|---|
| **Balance** | Cash balance of the account. Does not include unrealized P&L of open positions |
| **Margin Free** | Funds available for new orders. Balance − Used Margin |
| **Max Balance** | The highest balance value from the past to the present |
| **Drawdown (DD)** | Decline from the maximum balance. Calculated as Max Balance − Current Balance |
| **Credit** | Bonus funds granted by the broker |

## File Structure

```
AccountStatus/
├── AccountStatus.ex5      ← For MT5
├── AccountStatus.ex4      ← For MT4
└── USER_MANUAL.md         ← User manual (Japanese)
└── USER_MANUAL.en.md      ← User manual (English)
```

## Parameters

| Parameter | Default | Description |
|---|---|---|
| Balance | ON | Show Balance line |
| Margin Free | ON | Show Margin Free line |
| Max Balance | ON | Show Max Balance line |
| Info Font Size | Large | Font size for mouseover popup |
| Add Credit to Balance | ON | Include broker bonus credit in balance |
| Scale Top (%) | 101 | Upper display limit. Values above 100 add margin above the maximum |
| Scale Bottom (%) | 0 | Lower display limit. Set to 95 to show only the top 5% of the range |

### Scale Setting Examples

The display range is specified as a percentage of the total value range (Max − Min = 100%).

| Setting | Top | Bottom | Effect |
|---|---|---|---|
| Full range (default) | 101 | 0 | Full range + 1% margin above |
| Top 5% only | 101 | 95 | Zooms in near the maximum value |
| Bottom 10% only | 10 | 0 | Zooms in near the minimum value |

## Requirements

- MetaTrader 5
- MetaTrader 4
