import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/pages/login_or_register.dart';



class RegisterPage extends StatefulWidget {
  final int userId;
   const RegisterPage({super.key, required this.userId});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

  // If running Flask on your computer and testing on Android Emulator:
  // final String api = "http://10.0.2.2:5000"; 
  // If testing on iOS Simulator or Web:
  final String api = "http://127.0.0.1:5000"; 

  Future<void> _showAlert(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _registerUser() async {
    final userid = widget.userId.toString();
    final username = _username.text.trim();
    final password = _password.text.trim();
    final confirmPWD = _confirmpassword.text.trim();

    if (username.isEmpty || password.isEmpty || confirmPWD.isEmpty) {
      _showAlert('Validation Error', 'Please ensure all fields are filled.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$api/createaccount'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userid': userid,
          'username': username,
          'password': password,
          'confirmPWD' : confirmPWD
        }),
      );
      
      if (response.statusCode == 201) {
        _showAlert(
          'Register Successful!', 
          'You have been successfully registered.',     
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginOrRegister()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showAlert('Register Failed', errorData['error'] ?? 'Failed.');
      }
    } catch (e) {
      _showAlert('Network Error', 'Could not connect to the server on $api.');
      print('HTTP Request Error: $e');
    }
  }
  
  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Registraion page'),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            TextField(
              controller: _username,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 50),

            TextField(
              controller: _password,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 50),

            TextField(
              controller: _confirmpassword,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                ),
                child: 
                Text('Create Account', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}