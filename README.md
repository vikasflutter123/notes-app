📝 Flutter Firebase Notes App

A beautifully designed Notes Application built with Flutter and Firebase, featuring authentication, real-time note syncing, and offline detection.

The app follows clean architecture principles using Provider for state management and supports both login and signup flows.

🚀 Features
🔐 Firebase Authentication

Email & Password login

Signup with validation

Logout support

🗂 Notes Management

Create, edit, delete notes

Real-time Cloud Firestore synchronization

Notes ordered by last updated time

📡 Offline Detection

Network connectivity detection using connectivity_plus

Prevents authentication actions when offline

Offline indicators across the app

🎨 Modern UI

Gradient-based design

Material components

Clean and readable layout

🧠 State Management

Provider & ChangeNotifier

Reactive UI updates

🛠 Tech Stack
Layer	Technology
Framework	Flutter 3.32.4
Language	Dart ^3.8.1
Backend	Firebase
Authentication	Firebase Authentication
Database	Cloud Firestore
State Management	Provider
Connectivity	connectivity_plus
Date Formatting	intl
📦 Project Setup
1️⃣ Prerequisites

Make sure you have the following installed:

Flutter 3.32.4

Dart ^3.8.1

Firebase CLI

npm install -g firebase-tools


FlutterFire CLI

dart pub global activate flutterfire_cli

2️⃣ Clone the Repository
git clone https://github.com/your-username/flutter-firebase-notes-app.git
cd flutter-firebase-notes-app

3️⃣ Install Dependencies
flutter pub get

4️⃣ Firebase Configuration

Create a Firebase project
👉 https://console.firebase.google.com

Add Android / iOS / Web apps as required

Enable Email/Password Authentication

Firebase Console → Authentication → Sign-in method


Enable Cloud Firestore

Firebase Console → Firestore Database → Start in test mode


Generate Firebase configuration

flutterfire configure


This will generate:

lib/firebase_options.dart

▶️ Running the App Locally
flutter run


Run on a specific device:

flutter run -d chrome
flutter run -d android
flutter run -d ios

🗃 Database Schema (Cloud Firestore)
📁 Collection: notes

Each document represents a single note:

{
"title": "Meeting Notes",
"content": "Discuss project timeline and milestones",
"user_id": "firebase_auth_user_uid",
"created_at": "Timestamp",
"updated_at": "Timestamp"
}

🔑 Indexing

Query used:

.where('user_id', isEqualTo: uid)
.orderBy('updated_at', descending: true)


Firestore may prompt you to create a composite index — follow the console link if required.

🔐 Authentication Approach

Uses Firebase Email & Password Authentication

Authentication state handled via:

FirebaseAuth.instance.authStateChanges()


Flow:

Login / Signup → Firebase Authentication

Session persists automatically

Logout clears the session

🌐 Offline Handling Strategy

Network status tracked using connectivity_plus

Authentication actions blocked when offline

Offline UI indicators shown on:

Login Screen

Notes List Screen

Note Edit Screen

Firestore automatically syncs data once connectivity is restored

🧩 Architecture Overview
lib/
│
├── main.dart
├── firebase_options.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── notes_provider.dart
│
│
├── models/
│   └── note_model.dart
├── auth/
│   └── auth_wrapper.dart
├── services/
│   └── connectivity_service.dart
│
├── screens/
│   ├── login.dart
│   ├── notes_list.dart
│   └── notes_edit.dart
│   └── user_profile.dart
│
├── themes/
│   └── app_theme.dart


Uses ChangeNotifier + Provider for clean and reactive state handling.

⚖️ Assumptions & Trade-offs
✅ Assumptions

Each user owns and accesses only their own notes

Notes are lightweight (text-based)

Firestore rules restrict access per authenticated user

⚠️ Trade-offs

No local database (Hive / SQLite)

Offline writes rely on Firestore cache

No pagination for large note lists

No password reset feature (can be added)

🔐 Recommended Firestore Security Rules
rules_version = '2';
service cloud.firestore {
match /databases/{database}/documents {
match /notes/{noteId} {
allow read, write: if request.auth != null
&& request.auth.uid == resource.data.user_id;
}
}
}

✨ Future Improvements

🔄 Pull-to-refresh

🗑 Undo delete

🔍 Search notes

🏷 Tags & categories

🧠 Local caching 


👨‍💻 Author

Vikas
Flutter Developer (3+ years experience)
Firebase • Provider • Clean UI Architecture
