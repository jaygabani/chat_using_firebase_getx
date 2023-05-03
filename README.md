# chat_using_firebase_getx

This project built in GETX state-management library.

The functionality is one to one chat and sending file with the use of 
    1. Firebase Authentication, 
    2. Firestore database 
    3. Firebase storage(for storing files)

Add in the Info.plist 
<array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <!-- TODO Replace this value: -->
                <!-- Copied from GoogleService-Info.plist key REVERSED_CLIENT_ID -->
                <string></string>
            </array>
        </dict>
</array>

Please add GoogleService-Info.plist file for iOS and Google-service.json for Android. 

