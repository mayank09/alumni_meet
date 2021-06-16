# alumnimeet

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Android Setup
-Checkout the "master" branch
-Add gradle.properties file under android root folder
-Add these lines
    org.gradle.jvmargs=-Xmx1536M
    android.useAndroidX=true
    android.enableJetifier=true

Google Map key Setup
- Add your project in google console, enable Map SDK for Android, and generate a key.
-Open gradle.properties file
-Add your google maps key by add this line 
    GOOGLE_MAP_KEY = "your_key"
- Rebuild Project


Firebase Setup
-Create your project in Firebase console
-Add SHA1 and SHA256 
-Enable Authentication and Firestore Cloud DB for your project
-Download "google-services.json" file from Firebase console
-Put this file under "android/app" folder
-Rebuild Project


     


