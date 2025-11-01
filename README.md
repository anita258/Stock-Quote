# Stock Quote

A Flutter application that provides real-time and historical stock data using the **Alpha Vantage API**.  
It displays live prices, market overview, stock details, and supports a personalized watchlist with local caching.

---

## Features

- **Market Overview**
  - Displays live data for major stocks (AAPL, TSLA, MSFT, GOOGL)
  - Auto-refreshes every 60 seconds
  - Tap any stock to view detailed info

- **Stock Detail Screen**
  - Shows live stock price, daily change, and volume
  - Displays historical data chart
  - Fetches company name and market capitalization using the **OVERVIEW** endpoint

- **Search**
  - Search any stock symbol to view full details instantly

- **Watchlist**
  - Add or remove stocks to a personalized watchlist
  - Stored locally using **GetStorage**

- **Offline Caching**
  - Last viewed stock and watchlist are persisted across sessions

- **Real-Time Refresh**
  - Market overview refreshes automatically every 60 seconds

- **Loading Animations**
  - Smooth Lottie animation while fetching data

---

##  Tech Stack

| Component | Technology |
|------------|-------------|
| Framework | Flutter |
| State Management | GetX |
| Local Storage | GetStorage |
| API | Alpha Vantage |
| HTTP Client | Dio |
| Charting | Syncfusion Flutter Charts |
| Testing | flutter_test |

---

## ⚙️ Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/stock_quote.git
   cd stock_quote
