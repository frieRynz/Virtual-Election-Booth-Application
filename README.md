# Virtual-Election-Booth-Application
To develop a program to simulate a real online voting (like prime minister or president election) which can maintain the security close to the real voting, e.g., voter authentication, repeated voting protection, anonymity of voting, any type of cheating protection.

# Frontend Setup
1) Please make sure that your device has Dart, Flutter, and VsCode installed on your device.
- To get started, open the VsCode, and type Ctrl + Shift + P and select 'New Flutter Project'
- After that, copy everything inside the lib folder located in our frontend folder, and paste it to your flutter project folder. This is the clear directory for it: `/frontend/lib`
- Then, copy the whole 'assets' folder located in our frontend folder, and paste it in youe flutter project folder: `/frontend/assets/images`

2) Please add these lines to the line #60 in the *pubspec.yaml*, to allow our application logo to be shown.
```
assets:
    - assets/images/
```

3) For our application demonstration, we primarily use chrome to run the demo, but if you would like to run the demo on Andriod Emulator,
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
But, if you would like to use chrome to run the demo, you could do so without fixing any code.

4) This is the dependency required to be installed at the frontend's terminal: 
```
flutter pub add http
```

# Backend Setup
1) Please use this command to install all of the dependencies for the backend.
```
pip install requirements.txt
```

2) Create a .env file inside the backend folder with these following lines of code : 
```
user=thaiVote
password=12345678@
host=localhost 
dbname=virtual_elec_booth

SECRET_KEY="9ffea8ed6000588278edc942e403fa0879a341bc124f47b3"
```

# Database Setup
1) Please open the .sql scripts in the Database folder on your local MySQL and run these files respectively: 
- virtual_election_booth_DB_1
- dummy_info_election

2) Run this queries on your local MySQL to create a user for database connection: 
```
CREATE USER 'thaivote'@'localhost' IDENTIFIED BY '12345678@';
```
```
GRANT ALL PRIVILEGES ON virtual_elec_booth.* TO 'thaivote'@'localhost' WITH GRANT OPTION;
```
```
FLUSH PRIVILEGES;
```

# Application Utilization Guide
1) On you local MySQL, run this script to see/select citizens to test the demo:
```
SELECT * FROM citizen_list;
```
