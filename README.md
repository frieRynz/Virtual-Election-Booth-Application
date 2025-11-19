# Virtual-Election-Booth-Application
To develop a program to simulate a real online voting (like prime minister or president election) which can maintain the security close to the real voting, e.g., voter authentication, repeated voting protection, anonymity of voting, any type of cheating protection.

# Frontend Setup
For our application demonstration, we primarily use chrome to run the demo, but if you would like to run the demo on Andriod Emulator,
you have to change the port number from this line: 
```
final String api = "http://127.0.0.1:5000"; // Chrome
```
to this line: 
```
final String api = "http://10.0.2.2:5000"; // Andriod Emu
```
To these dart files: 
- home_screen.dart
- OTP_page.dart
- register_page.dart
- auth_service.dart (in the services folder /lib/services)
  
You can spot the *String api* line under the State's class initiation.

Please add these lines to the line #60 in the *pubspec.yaml*, to allow our application logo to be shown.
```
assets:
    - assets/images/
```

And this is the dependency required to be installed at the frontend's terminal: 
```
flutter pub add http
```

# Backend Setup
Please use this command to install all of the dependencies for the backend.
```
pip install requirements.txt
```

# Database Setup
Please open the .sql scripts in the Database folder on your local MySQL and run these files respectively: 
- virtual_election_booth_DB_1
- dummy_info_election
