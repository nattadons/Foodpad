# FoodPad 🍳 - Culinary Adventure App

## 📱 Project Overview

FoodPad is an innovative mobile application that transforms cooking into an exciting and engaging experience. Combining recipe management with gamification, the app makes learning and preparing meals fun and interactive.

## 🚀 Technologies

### Development
- Flutter
- Dart
- Firebase

### Key Features
- Recipe Repository
- Gamification Elements
- User Authentication
- Cloud Storage

## ✨ Features

### 🍽 Recipe Management
- Extensive recipe collection
- Detailed cooking instructions
- Ingredient lists
- Cooking time and difficulty levels

### 🏆 Gamification
- Cooking challenges
- Achievement system
- Experience points
- Skill progression
- Reward mechanisms

### 🔥 Firebase Integration
- User authentication
- Cloud database
- Real-time updates
- User progress tracking

## 🛠 Prerequisites

- Flutter SDK (2.x or later)
- Dart SDK
- Android Studio / VS Code
- Firebase Account

## 📦 Installation

### Clone Repository
```bash
git clone https://github.com/[YOUR_USERNAME]/foodpad.git
cd foodpad
```

### Install Dependencies
```bash
flutter pub get
```

## 🔧 Firebase Setup

1. Create Firebase Project
2. Enable Authentication
3. Set up Firestore Database
4. Add Firebase Configuration
   - Download `google-services.json`
   - Place in `android/app/` directory

## 🌐 Environment Configuration

### Firebase Configuration
```dart
// lib/core/config/firebase_config.dart
class FirebaseConfig {
  static const apiKey = 'YOUR_FIREBASE_API_KEY';
  static const projectId = 'YOUR_PROJECT_ID';
  // Other Firebase configurations
}
```

## 🚀 Running the App

### Development Mode
```bash
flutter run
```

### Build Release
```bash
flutter build apk
flutter build ios
```

## 🧪 Testing

```bash
flutter test
```

