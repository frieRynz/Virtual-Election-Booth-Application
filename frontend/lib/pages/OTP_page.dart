import 'package:frontend/widgets/hover_gradient_button.dart';

import '/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/gestures.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert'; 


class OTPScreen extends StatefulWidget {
  final String nationalId;
  const OTPScreen({super.key, required this.nationalId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  final TextEditingController _otpCred1 = TextEditingController();
  final TextEditingController _otpCred2 = TextEditingController();
  final TextEditingController _otpCred3 = TextEditingController();
  final TextEditingController _otpCred4 = TextEditingController();

  // If running Flask on your computer and testing on Android Emulator:
  // final String api = "http://10.0.2.2:5000"; 
  // If testing on iOS Simulator or Web:
  final String api = "http://127.0.0.1:5000"; 

  Timer? _timer;
  int _remainingSeconds = 60;
  // bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    _otpCred1.dispose();
    _otpCred2.dispose();
    _otpCred3.dispose();
    _otpCred4.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          // _isResendEnabled = true;
        });
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    String twoDigitMinutes =
        (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    String twoDigitSeconds =
        (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  // void _resendCode() {
  //   if (!_isResendEnabled) return;

  //   print("Resend code logic triggered for ID: ${widget.nationalId}");
    
  //   setState(() {
  //     _isResendEnabled = false;
  //     _remainingSeconds = 60;
  //   });
  //   _startTimer();
  // }

   Future<int> _fetchUserId(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse('$api/get_user_id?national_id=$nationalId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['user_id'];
      } else {
        final errorData = jsonDecode(response.body);
        _showAlertDialog('Fetch Failed', errorData['error'] ?? 'Could not retrieve user ID.');
        return 0;
      }
    } catch (e) {
      _showAlertDialog('Network Error', 'Could not connect to the server on $api.');
      print('HTTP GET Request Error: $e');
      return 0;
    }
   }

  Future<void> _verifyOTP() async {
    final otp = _otpCred1.text + _otpCred2.text + _otpCred3.text + _otpCred4.text;
    
    if (otp.length != 4) {
      _showAlertDialog('Error', 'Please enter the 4-digit OTP.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$api/verify_otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'National_ID': widget.nationalId,
          'otp': otp,
        }),
      );

      if (response.statusCode == 201) {
        _timer?.cancel();
        final int userId = await _fetchUserId(widget.nationalId);

        _showAlertDialog(
          'Verification Successful!', 
          'Moving on to create account',
          onClose: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage(userId: userId)), 
            );
          }
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showAlertDialog('Verification Failed', errorData['error'] ?? 'Invalid OTP or expired.');
      }
    } catch (e) {
      _showAlertDialog('Network Error', 'Could not connect to the server on $api.');
      print('HTTP Request Error: $e');
    }
  }

  void _showAlertDialog(String title, String message, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onClose?.call();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 209, 238),
      // appBar: AppBar(
      // title: Text('OTP verification page'),
      // centerTitle: true,
      // ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  'OTP verification',
                  style: TextStyle(fontSize: 50, 
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 3),

                Text(
                  'Please enter the OTP sent to your SMS to complete your verification for ID: ${widget.nationalId}.',
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: TextField(
                        controller: _otpCred1,
                        keyboardType: TextInputType.number, // Ensure numeric input
                        textAlign: TextAlign.center,
                        maxLength: 1, // Limit input to one digit
                        decoration: InputDecoration(
                          filled: true, 
                          fillColor: Colors.white, 
                          counterText: "", // Hide the counter
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          if (value.length == 1) FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),  
                    
                  SizedBox(width: 20),

                    SizedBox( 
                      width: 72,
                      height: 72,
                      child:
                        TextField(
                        controller: _otpCred2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          filled: true, 
                          fillColor: Colors.white, 
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          if (value.length == 1) FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                  SizedBox(width: 20),

                    SizedBox( 
                      width: 72,
                      height: 72,
                      child:
                        TextField(
                        controller: _otpCred3,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          filled: true, 
                          fillColor: Colors.white, 
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          if (value.length == 1) FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),

                  SizedBox(width: 20),

                    SizedBox( 
                      width: 72,
                      height: 72,
                      child:
                        TextField(
                        controller: _otpCred4,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          filled: true, 
                          fillColor: Colors.white, 
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          if (value.length == 1) FocusScope.of(context).unfocus(); // Close keyboard after last digit
                        },
                      ),
                    ),
                  ],
                  ),

                  SizedBox(height: 30),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Remaining time: ',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      children: [
                        TextSpan(
                          text: _formatTime(_remainingSeconds),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                
                SizedBox(height: 50),

                Center(
                  child: HoverGradientButton(text: 'Verify', onPressed: _verifyOTP),
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
