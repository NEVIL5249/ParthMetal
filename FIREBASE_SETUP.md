# Firebase Setup Guide for Parth Metal App

This guide will help you set up Firebase Authentication and Firestore Database for your Flutter app.

## Prerequisites

1. A Google account
2. Flutter SDK installed
3. Firebase CLI (optional but recommended)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter your project name (e.g., "parth-metal-app")
4. Choose whether to enable Google Analytics (recommended)
5. Click "Create project"

## Step 2: Enable Authentication

1. In your Firebase project console, go to "Authentication" in the left sidebar
2. Click "Get started"
3. Go to the "Sign-in method" tab
4. Enable "Phone" authentication:
   - Click on "Phone"
   - Toggle the "Enable" switch
   - Add your test phone numbers (for development)
   - Click "Save"

## Step 3: Set up Firestore Database

1. In your Firebase project console, go to "Firestore Database" in the left sidebar
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location for your database (choose the closest to your users)
5. Click "Done"

## Step 4: Get Firebase Configuration

### For Web Platform:
1. In your Firebase project console, click the gear icon next to "Project Overview"
2. Select "Project settings"
3. Scroll down to "Your apps" section
4. Click the web icon (</>) to add a web app
5. Register your app with a nickname (e.g., "parth-metal-web")
6. Copy the configuration object
7. Replace the placeholder values in `web/firebase-config.js` with your actual configuration

### For Android Platform:
1. In the same project settings page, click the Android icon to add an Android app
2. Enter your package name: `com.example.parthmetal`
3. Download the `google-services.json` file
4. Place it in the `android/app/` directory

### For iOS Platform:
1. In the same project settings page, click the iOS icon to add an iOS app
2. Enter your bundle ID: `com.example.parthmetal`
3. Download the `GoogleService-Info.plist` file
4. Place it in the `ios/Runner/` directory

## Step 5: Update Configuration Files

### Web Configuration (`web/firebase-config.js`):
```javascript
const firebaseConfig = {
  apiKey: "your-actual-api-key",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "your-messaging-sender-id",
  appId: "your-app-id"
};
```

### Android Configuration:
1. Update `android/app/build.gradle`:
```gradle
dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
}
```

2. Add to the bottom of `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

3. Update `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

### iOS Configuration:
1. Update `ios/Podfile` to include Firebase pods
2. Run `cd ios && pod install` in your terminal

## Step 6: Security Rules for Firestore

In your Firestore Database console, go to "Rules" and update the rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 7: Test the Setup

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to test your app
3. Try the login flow with a test phone number

## Troubleshooting

### Common Issues:

1. **"Firebase not initialized" error**:
   - Make sure you've added the configuration files correctly
   - Check that Firebase.initializeApp() is called in main.dart

2. **Phone authentication not working**:
   - Ensure phone authentication is enabled in Firebase Console
   - Add test phone numbers for development
   - Check that you're using the correct country code (+91 for India)

3. **Firestore permission denied**:
   - Check your Firestore security rules
   - Ensure the user is authenticated before accessing data

4. **Build errors**:
   - Make sure all configuration files are in the correct locations
   - Run `flutter clean` and `flutter pub get`

## Production Considerations

1. **Security Rules**: Update Firestore rules for production
2. **Phone Numbers**: Remove test phone numbers and enable production phone verification
3. **Analytics**: Enable Firebase Analytics for better insights
4. **Monitoring**: Set up Firebase Crashlytics for error tracking

## Support

If you encounter any issues, check:
- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Firebase Console Help](https://firebase.google.com/support)
- Flutter and Firebase community forums 