import '/pages/OTP_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController _nat_IDController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  // final TextEditingController _dob = TextEditingController(); 

  // If running Flask on your computer and testing on Android Emulator:
  // final String api = "http://10.0.2.2:5000"; 
  // If testing on iOS Simulator or Web:
  final String api = "http://127.0.0.1:5000"; 

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
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
    final nationalId = _nat_IDController.text.trim();
    final phoneNo = _phoneNoController.text.trim();
    // final dob = _dob.text.trim();

    if (nationalId.isEmpty || phoneNo.isEmpty) {
      _showAlert('Validation Error', 'Please ensure all fields are filled.');
      return;
    }
    
    if (nationalId.length != 13) {
      _showAlert('Validation Error', 'National ID must be exactly 13 digits.');
      return;
    }

    if (phoneNo.length != 10) {
      _showAlert('Validation Error', 'Phone Number must be exactly 10 digits.');
      return;
    }


    try {
      final response = await http.post(
        Uri.parse('$api/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'National_ID': nationalId,
          'Phone_no': phoneNo,
          // 'DOB': dob,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final registeredId = responseData['id'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(nationalId: registeredId),
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showAlert('Registration Failed', errorData['error'] ?? 'An unknown error occurred.');
      }
    } catch (e) {
      _showAlert('Network Error', 'Could not connect to the server on $api.');
      print('HTTP Request Error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Authentication page'),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nat_IDController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(13),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Enter your National ID (13 digits)',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 13,
            ),

            const SizedBox(height: 50),

            TextField(
              controller: _phoneNoController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Enter your Phone Number (10 digits)',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 10,
            ),

            const SizedBox(height: 50),

            

            const SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                ),
                onPressed: _registerUser, 
                child: 
                const Text('Authenticate', style: TextStyle( fontSize: 18,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
