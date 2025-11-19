import 'package:flutter/material.dart';
import '/pages/home_screen.dart';
import 'login_page.dart';
import '../widgets/hover_gradient_button.dart';

class LoginOrRegister extends StatefulWidget {
   const LoginOrRegister({super.key});

  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 209, 238),
      body: 
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
            
            HoverGradientButton(
              text: 'Register', 
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              } ,
            ),
            const SizedBox(height: 100),

            Center(
              child: HoverGradientButton(
                text: 'Log in',
                onPressed: () {
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> LoginPage()));
                  },
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
