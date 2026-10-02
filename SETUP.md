# SkillConnect Android Setup

Follow these steps to configure your app to run on Android with Firebase.

## 1. Firebase Project Setup
1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Enable Authentication: Go to Build > Authentication, and enable **Email/Password** and **Google** sign-in providers.
3. Enable Firestore: Go to Build > Firestore Database and create a database in production mode.
4. Upgrade to Blaze? NO, stay on the **FREE Spark plan** as requested.

## 2. FlutterFire CLI
Run the following command in the terminal to configure Firebase for this app:
```bash
flutterfire configure --project=YOUR_PROJECT_ID
```
(Replace `YOUR_PROJECT_ID` with your actual Firebase project ID). It will generate `firebase_options.dart`.

## 3. SHA Certificates
To make Google Sign-In work on Android:
1. Generate the debug keystore certificates by running:
```bash
cd android
./gradlew signingReport
```
2. Copy the `SHA1` and `SHA-256` keys for the `debugAndroidTest` or `debug` variant.
3. Go to Firebase Console > Project Settings > General > Your Apps (Android) and click **Add fingerprint**. Add both SHA1 and SHA256.

## 4. Firestore Rules and Indexes
1. Ensure the Firebase CLI is installed (`npm install -g firebase-tools`).
2. Login to Firebase: `firebase login`
3. Initialize Firestore (if not already done): `firebase init firestore`
4. Deploy the rules and indexes:
```bash
firebase deploy --only firestore
```

## 5. Environment Variables (Gemini API)
1. Copy `env.example.json` to `env.json`:
```bash
cp env.example.json env.json
```
2. Open `env.json` and replace `YOUR_GEMINI_API_KEY_HERE` with your actual free-tier Gemini API key.

## 6. Admin User Setup
To access the Admin panel:
1. Sign up a new user in the app normally.
2. Go to the Firebase Console > Firestore Database.
3. Find the `users` collection, locate your user document, and change the `role` field from `"customer"` or `"professional"` to `"admin"`.

## 7. Seed Demo Data
To seed realistic dummy data (professionals, bookings, etc.):
1. Run the app in debug mode.
2. Long press the SkillConnect logo on the Splash screen to trigger the seeding process.
Note: You need at least one authenticated user account (from Step 6) to run the app before seeding.
