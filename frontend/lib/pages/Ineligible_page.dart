import 'package:flutter/material.dart';

class IneligiblePage extends StatefulWidget {
   const IneligiblePage({super.key});

  @override
  _IneligibleState createState() => _IneligibleState();
}

class _IneligibleState extends State<IneligiblePage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
      title: Text('Ineligible page'),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are not eligible to vote.',
              style: TextStyle(fontSize: 50, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}