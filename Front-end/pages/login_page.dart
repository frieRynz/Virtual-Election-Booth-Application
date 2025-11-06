import 'package:flutter/material.dart';
import 'package:app_pages/pages/Ineligible_page.dart';
import 'package:app_pages/pages/voting_page.dart';



class LoginPage extends StatefulWidget {
   const LoginPage({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String worngUsername = "admin";
  String worngPassword = "admin123";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Login page'),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
          Center(
            child:Container(
              constraints: BoxConstraints(maxWidth: 300),
              child:TextField(
                  controller: _username,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
            )
          ),
            
            SizedBox(height: 50),
            
            Center(
              child:Container(
                constraints: BoxConstraints(maxWidth: 300),
                child:TextField(
                    controller: _password,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
              )
            ),
            
            SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if(_username.text == worngUsername && _password.text == worngPassword){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>
                      IneligiblePage()));
                  }else {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>
                      VotingPage()));
                  }
                  },
                  style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                ),
                child: 
                Text('Login',
                      style: TextStyle(
                        fontSize: 18,
                      )
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
