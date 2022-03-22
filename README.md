# agrargo
Flutter App Project der Gruppe Agrargo |WWI19SCA DHBW Mannheim


## Deployment
https://medium.com/swlh/firebase-hosting-and-automatic-deployment-with-github-actions-for-flutter-web-7713b00fb620
https://medium.com/flutter/must-try-use-firebase-to-host-your-flutter-app-on-the-web-852ee533a469
https://watacorp.com/blog/deploy-web-with-flutter-2

Um Codeänderungen im master-Branch zu Veröffentlichen:
1. Commit & Push Änderungen zu github
2. run "flutter build web" in Android Studio Terminal
3. run "firebase deploy" in Android Studio Terminal

Firebase SetUp:
https://stackoverflow.com/questions/23645220/firebase-tools-bash-firebase-command-not-found


TODO für Christina & Verena
Automatischer Code Formatter
https://stackoverflow.com/questions/27092772/auto-code-formatting-in-android-studio

Aktiviere: File --> Settings --> Language & Frameworks --> Flutter --> 'Format code on save'.


#How to merge
1. Änderung auf lokalen Branch (z.B.dev_ch)
2. Commit & push lokale Änderung auf dev_ch
3. checkout master-Branch
4. push master-Branch
5. run flutter build web in Terminal auf dem master-Branch
6. run firebase deploy in Terminal auf dem master-Branch


#install firebase_cli configuration
https://firebase.flutter.dev/docs/cli/#installation


#Google Signin
ihre Client-ID: 900179231722-jera6234lno2o19akguq9vbrv6do3f01.apps.googleusercontent.com
Ihr Clientschlüssel: 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
https://developers.google.com/identity/sign-in/web/sign-in#before_you_begin

Öffentlicher Name des Projektes: project-277800976688

#FirebaseSignin (Dokumentation nach der ich den Login/Register Prozess )
https://github.com/sbis04/flutter-authentication/blob/master/lib/utils/fire_auth.dart