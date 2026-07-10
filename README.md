# 📈 Zenith - Trading Simulation Platform

Zenith is a modern iOS paper trading application built with **SwiftUI** that allows users to practice cryptocurrency trading without risking real money.

The app provides real-time market data, allows users to open Buy/Sell positions, tracks live profit & loss, and stores user portfolios securely using Firebase Authentication and Firestore.

---

# ✨ Features

- 🔐 Firebase Authentication
- 👤 User Profile
- 📊 Real-time Cryptocurrency Prices
- 💹 Buy & Sell Trading
- 📈 Live Profit & Loss Calculation
- 💰 Virtual Wallet Balance
- 📋 Trade History
- 🔒 Face ID / Biometric Lock
- ☁️ Firebase Firestore Database
- 🎨 Modern SwiftUI Interface
- ⚡ MVVM Architecture
- 📱 Native iOS Experience

---

# 📸 Screenshots

| Home | Coin Details | Trading |
|------|-------------|----------|
| Add Screenshot | Add Screenshot | Add Screenshot |

| Open Positions | Profile | Authentication |
|----------------|---------|----------------|
| Add Screenshot | Add Screenshot | Add Screenshot |

---

# 🎥 Demo

Watch the complete demo below.

> Add the video link here after uploading it.

Example:

https://github.com/user-attachments/assets/your-video-id

---

# 🛠 Tech Stack

- Swift
- SwiftUI
- Firebase Authentication
- Firebase Firestore
- MVVM Architecture
- URLSession
- LocalAuthentication (Face ID)
- SDWebImageSwiftUI
- REST APIs
- Combine

---

# 🏗 Architecture

```
Presentation
│
├── SwiftUI Views
│
├── ViewModels (MVVM)
│
├── Services
│      ├── Firebase
│      ├── Authentication
│      ├── API Services
│
├── Models
│
└── Firestore Database
```

---

# 📂 Project Structure

```
Zenith
│
├── Models
├── Views
├── ViewModels
├── Services
├── Components
├── Utilities
├── Assets
└── Resources
```

---

# 🔥 Firebase

The application uses Firebase for

- User Authentication
- Cloud Firestore
- User Portfolio
- Open Positions
- Trade History
- Wallet Balance

Each user has their own secure trading data.

---

# 📈 Trading Logic

- Users can Buy or Sell cryptocurrencies.
- Every trade is saved in Firestore.
- Profit/Loss updates automatically using live market prices.
- Closing a position updates the user's wallet balance.
- Trade history is maintained for every user.

---

# 🚀 Getting Started

## Clone the repository

```bash
git clone https://github.com/yourusername/Zenith.git
```

## Open in Xcode

```
Zenith.xcodeproj
```

## Install Dependencies

The project uses Swift Package Manager.

Packages include:

- Firebase
- SDWebImageSwiftUI

---

# ⚙️ Requirements

- Xcode 16+
- iOS 18+
- Swift 6
- Firebase Project

---

# Future Improvements

- Candlestick Charts
- TradingView Integration
- Watchlist
- Push Notifications
- Portfolio Analytics
- Dark Mode Improvements
- Multi-language Support

---

# 👨‍💻 Author

Samyack Bansode

iOS Developer

```
