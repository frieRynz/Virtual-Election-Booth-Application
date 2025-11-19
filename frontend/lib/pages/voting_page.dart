import 'package:flutter/material.dart';
import 'package:frontend/widgets/hover_gradient_button.dart';
import '/services/auth_service.dart';
import '/pages/login_or_register.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key, required int voterId});

  @override
  _VotingPageState createState() => _VotingPageState();

}


class _VotingPageState extends State<VotingPage> {
  bool is1Checked = false; 
  bool is2Checked = false; 
  bool is3Checked = false; 
  bool is4Checked = false; 
  int _selectedCandidateId = 0;

  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String _errorMessage = '';

  void _handleVote(int candidateId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _authService.submitVote(candidateId);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Vote Submitted'),
              content: const Text('Thank you for voting!'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginOrRegister()),
                      (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Vote Failed'),
              content: const Text('You can only vote once!!'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginOrRegister()),
                      (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 209, 238),
      
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      _candidateCard(id: 1, name: 'Mr. Bulbasuar',
                       imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png', 
                       bgColor: Colors.green.shade100),

                      const SizedBox(width: 20),

                      _candidateCard(id: 2, name: 'Mr. Charmander',
                       imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png', 
                       bgColor: Colors.red.shade100),

                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      _candidateCard(id: 3, name: 'Mr. Squirtle',
                       imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png', 
                       bgColor: Colors.blue.shade100),

                      const SizedBox(width: 20),

                      _candidateCard(id: 4, name: 'Mr. Pikachu',
                       imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png', 
                       bgColor: Colors.yellow.shade100),
                      
                    ],
                  ),

                  SizedBox(height: 35),

                  _comfirmCandidateButton('Confirm'),
                ],
              ),
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

  Widget _comfirmCandidateButton(String label) {
    return HoverGradientButton(text: label, onPressed: () {_handleVote(_selectedCandidateId);});
  }

  Widget _candidateCard({required int id, required String name, required String imageUrl, required Color bgColor}){
    bool isSelected = _selectedCandidateId == id;
    return Column(
                  children: [
                    Container(width: 160,height: 160,
                      decoration: BoxDecoration(
                        color: bgColor, //
                        border: Border.all(
                          color: Colors.black, 
                          width: 1.5,
                        ),
                         borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Column(
                          children: [
                              Expanded(child: 
                              Image.network(imageUrl,
                                fit: BoxFit.contain,
                              ),),
                              Text(
                                name,
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                            ]
                          ),
                        ),
                        const SizedBox(height: 10),
                        _selectCandidateButton('Candidate No.$id'
                                                ,isSelected,
                                                (val) {
                                                  setState(() {
                                                    _selectedCandidateId = (val == true) ? id : 0;
                                                  });
                                                }),
                        ],
                      );
  }

    Widget _selectCandidateButton(String label, bool option, Function(bool?) onChanged){
      return Container(
        width:180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
        ),
        child:CheckboxListTile(
            title: Text(label, style: const TextStyle(fontSize: 16)),
            value: option,
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            contentPadding: EdgeInsets.all(8),
            activeColor: const Color(0xFF1E3C72),
            onChanged: onChanged,
          )
      );
  }
}
