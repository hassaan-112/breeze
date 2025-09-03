# 🌤️ Breeze – Weather App

Breeze is a modern and interactive weather app built in **Flutter** as part of my **7 Days – 7 Apps Challenge (Day 7)**.  
It combines a clean UI with real-time weather data to provide users with an engaging experience.
 
---

## ✨ Features
- 📍 **Location-based weather**
    - Gets location permission and automatically fetches user’s **latitude & longitude**.
    - Displays real-time weather details for the current location.

- 🌡️ **Weather details**
    - Current temperature
    - Visibility
    - Cloud coverage
    - Rain percentage
    - Wind speed

- 🎨 **Dynamic UI with animations**
    - Background color & **Lottie animations** change based on weather conditions:
        - ☀️ Day → Yellowish with Sun animation
        - 🌙 Night → Blue with Moon animation
        - ☁️ Cloudy → Greyish with Cloud animations
        - 🌧️ Rainy → Bluish with Rain animation

- 🔎 **Search functionality**
    - Search and view weather of any **city in Pakistan**

- 📅 **Forecast view**
    - Hourly forecast of the whole day

---

\

## 🛠️ Tech Stack
- **Flutter** (Frontend & Backend integration)
- **Weather API** (for fetching live weather data)
- **Lottie Animations** (for weather effects)
- **Geolocator** (for location services)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- Weather API key

### Installation
```bash
# Clone the repo
git clone https://github.com/your-username/breeze-weather.git

# Navigate to project directory
cd breeze-weather

# Get dependencies
flutter pub get

# Run the app
flutter run
