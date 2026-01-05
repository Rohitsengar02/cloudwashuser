# Cloud User App - Flutter Migration

## Overview
This is the **Customer App** for the Cloud Wash ecosystem, migrated from React Native (Expo) to Flutter.

## Features Implemented

### ✅ Authentication
- Login Screen with Phone Number
- OTP Verification (simulated)
- Token Storage (SharedPreferences)

### ✅ Home & Navigation
- Bottom Navigation (Home, Bookings, Rewards, Profile)
- Home Screen with:
  - Location Header (tap to select)
  - Search Bar
  - Category Grid

### ✅ Location & Maps
- Location Permission Handling
- Google Maps Integration
- Geocoding (Address from coordinates)
- Map Picker Screen

### ✅ Service Booking Flow
- Category Screen (service listing)
- Service Details Screen
- Cart Screen (add/remove items)
- Checkout Screen (date/time selection, order summary)

### ✅ User Profile
- Profile Screen with options
- Logout functionality

### ✅ Bookings Management
- Upcoming Bookings Tab
- Past Bookings Tab
- Booking Cards with Status

### ✅ Rewards
- Points Display
- Refer & Earn Section
- Rewards History

## Architecture
- **State Management**: Riverpod
- **Navigation**: GoRouter with Nested Navigation
- **Networking**: Dio with Interceptors
- **Code Generation**: build_runner for Riverpod & JSON

## Project Structure
```
lib/
├── core/
│   ├── config/         # App configuration
│   ├── models/         # Data models
│   ├── network/        # API client
│   ├── router/         # GoRouter setup
│   ├── services/       # Location, etc.
│   ├── storage/        # Token storage
│   └── theme/          # App theme
└── features/
    ├── auth/           # Login, OTP
    ├── bookings/       # Booking history
    ├── cart/           # Cart logic
    ├── home/           # Home, Categories, Services
    ├── location/       # Map picker
    ├── profile/        # User profile
    └── rewards/        # Rewards screen
```

## Running the App
```bash
cd cloudwasher/cloud_user
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Next Steps
- Connect to real backend API
- Implement real Firebase OTP
- Add push notifications
- Polish animations
