# Virtual-Election-Booth-Application
To develop a program to simulate a real online voting (like prime minister or president election) which can maintain the security close to the real voting, e.g., voter authentication, repeated voting protection, anonymity of voting, any type of cheating protection.

# FrontEnd Installation
For our application demonstration, we primarily use chrome to run the demo, but if you would like to run the demo on Andriod Emulator,
you have to change the port number from this line: 
```
final String api = "http://127.0.0.1:5000"; // Chrome
```
to this line  : 
```
final String api = "http://10.0.2.2:5000"; // Andriod Emu
```
To these dart files : 
- home_screen.dart
- OTP_page.dart
- register_page.dart
- auth_service.dart (services)
You can spot the *String api* line under the State's class initiation.

And this is the dependency required to be installed at the frontend's terminal : 
```
flutter pub add http
```
