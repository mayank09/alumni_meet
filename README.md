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

###Android Setup
<p>Checkout the "master" branch</p>
<p>-Add gradle.properties file under android root folder</p>
<p>-Add these lines</p>
    <pre><code>
    org.gradle.jvmargs=-Xmx1536M
    android.useAndroidX=true
    android.enableJetifier=true
    </code></pre>

###Google Map key Setup
<p>- Add your project in google console, enable Map SDK for Android, and generate a key.</p>
<p>-Open gradle.properties file</p>
<p>-Add your google maps key by add this line </p>
    <pre><code>
    GOOGLE_MAP_KEY = "your_key"
    </code></pre>
<p>- Rebuild Project</p>


###Firebase Setup
<p>-Create your project in Firebase console</p>
<p>-Add SHA1 and SHA256</p>
<p>-Enable Authentication and Firestore Cloud DB for your project</p>
<p>-Download "google-services.json" file from Firebase console</p>
<p>-Put this file under "android/app" folder</p>
<p>-Rebuild Project</p>


     


