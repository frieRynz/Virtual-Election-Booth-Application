import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/pages/login_or_register.dart';
import '../widgets/hover_gradient_button.dart';



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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 209, 238),
      body: Stack(
        children: [
          Padding(
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
                    filled: true, 
                    fillColor: Colors.white, 
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1E3C72),),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',

                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF1E3C72), width: 2),
                   ),
                  ),
                ),

                SizedBox(height: 50),

                // TextField(
                //   controller: _password,
                //   keyboardType: TextInputType.text,
                //   obscureText: true,
                //   decoration: InputDecoration(
                //     labelText: 'Password',
                //     border: OutlineInputBorder(),
                //   ),
                // ),

                TextField(
                  controller: _password,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true, 
                    fillColor: Colors.white, 
                    prefixIcon: Icon(Icons.key_rounded, color: Color(0xFF1E3C72),),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',

                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF1E3C72), width: 2),
                   ),
                  ),
                  obscureText: true,
                ),

                SizedBox(height: 50),

                // TextField(
                //   controller: _confirmpassword,
                //   keyboardType: TextInputType.text,
                //   obscureText: true,
                //   decoration: InputDecoration(
                //     labelText: 'Confirm Password',
                //     border: OutlineInputBorder(),
                //   ),
                // ),

                TextField(
                  controller: _confirmpassword,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true, 
                    fillColor: Colors.white, 
                    prefixIcon: Icon(Icons.key_sharp, color: Color(0xFF1E3C72),),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',

                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF1E3C72), width: 2),
                   ),
                  ),
                  obscureText: true,
                ),

                SizedBox(height: 60),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: _registerUser,
                //       style: ElevatedButton.styleFrom(
                //       padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                //     ),
                //     child: 
                //     Text('Create Account', style: TextStyle(fontSize: 18)),
                //   ),
                // ),
                Center(
                  child:HoverGradientButton(text: 'Create Account', onPressed: _registerUser)
                ),
              ],
            ),
          ),

          Positioned(
              top: 0,
              left: (screenWidth - (screenWidth * 0.8)) / 2,
              width: screenWidth * 0.8,
              child: Container(
                height: 95,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)
                  ),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                  ],
                ),
                child:Center(
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Thai',style: TextStyle(
                      fontSize:32, // Make it larger like a header
                      fontWeight: FontWeight.bold,
                      color : const Color.fromARGB(255, 245, 195, 137)
                    ),),
                   SizedBox(width: 10),
                    Image.asset(
                    'images/vote_icon.png',
                    width: 80, // You can optionally set a width
                    height: 80, // You can optionally set a height
                  ),
                  ],),
                )
              ),
            ),
        ],
      ),

      
    );
  }
}