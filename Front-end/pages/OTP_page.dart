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
  bool _isResendEnabled = false;

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
          _isResendEnabled = true;
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

  void _resendCode() {
    if (!_isResendEnabled) return;

    print("Resend code logic triggered for ID: ${widget.nationalId}");
    
    setState(() {
      _isResendEnabled = false;
      _remainingSeconds = 60;
    });
    _startTimer();
  }

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
    return Scaffold(
      appBar: AppBar(
      title: Text('OTP verification page'),
      centerTitle: true,
      ),
      body: Padding(
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
              style: TextStyle(fontSize: 20, color: const Color.fromARGB(134, 67, 68, 68)),
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
            Center(
              child: Text.rich(
                TextSpan(
                  text: "Didn't get the code? ",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  children: [
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(
                        fontSize: 16,
                        color: _isResendEnabled ? Colors.blue : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: _isResendEnabled
                          ? (TapGestureRecognizer()..onTap = _resendCode)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                ),
                onPressed: _verifyOTP, 
                child: 
                Text('Verify', style: TextStyle( fontSize: 18,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
