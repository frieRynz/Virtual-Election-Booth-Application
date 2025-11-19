import '/pages/OTP_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/hover_gradient_button.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 209, 238),
      body: Stack(
     children: [ 
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 16),


                TextField(
                  controller: _nat_IDController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Enter your National ID (13 digits)',
                    filled: true, 
                    fillColor: Colors.white, 
                    prefixIcon: Icon(Icons.account_box, color: Color(0xFF1E3C72),),

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
                  maxLength: 13,
                ),

                const SizedBox(height: 50),

                TextField(
                  controller: _phoneNoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Enter your Phone Number (10 digits)',
                    filled: true, 
                    fillColor: Colors.white, 
                    prefixIcon: Icon(Icons.phone, color: Color(0xFF1E3C72),),

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
                  maxLength: 13,
                ),

                const SizedBox(height: 50),

                HoverGradientButton(text: 'Authenticate', onPressed: _registerUser)
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
