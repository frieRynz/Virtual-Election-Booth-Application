import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/pages/voting_page.dart';
import '../widgets/hover_gradient_button.dart';
import 'package:flutter/services.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = '';

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String username = _usernameController.text;
      String password = _passwordController.text;

      Map<String, dynamic> responseData = await _authService.login(username, password);

      int voterId = responseData['voter_ID'];

      if (mounted) { 
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => VotingPage(voterId: voterId)),
        );
      }

    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      backgroundColor: Color.fromARGB(255, 185, 209, 238),
      body: 
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextField(
                  controller: _usernameController,
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
                
                const SizedBox(height: 50),
                
                TextField(
                  controller: _passwordController,
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

                const SizedBox(height: 32),
                // Spinner OR the button
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  HoverGradientButton(text: 'Login', onPressed: _handleLogin),
                  
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
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