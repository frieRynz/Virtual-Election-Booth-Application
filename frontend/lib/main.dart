import 'package:flutter/material.dart';
import '/pages/login_or_register.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual Electiob booth application',
      theme: ThemeData(primarySwatch: Colors.blue), // Global theme
      home: LoginOrRegister(), // Set eiei as the main page
    );
  }
}
