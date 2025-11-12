import 'package:flutter/material.dart';
import '/pages/home_screen.dart';
import 'login_page.dart';


class LoginOrRegister extends StatefulWidget {
   const LoginOrRegister({super.key});

  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Do you have an account?'),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                ),
                child: 
                Text('Log in',
                      style: TextStyle(
                        fontSize: 18,
                      )
                      ),
              ),
            ),
            const SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                ),
                child: 
                Text('Register',
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