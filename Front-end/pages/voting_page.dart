import 'package:flutter/material.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  _VotingPageState createState() => _VotingPageState();

}


class _VotingPageState extends State<VotingPage> {
  bool is1Checked = false; 
  bool is2Checked = false; 
  bool is3Checked = false; 
  bool is4Checked = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Column(
                    children: [
                      Container(width: 180,height: 180,color: Colors.green,
                      child: Column(
                        children: [
                          Expanded(child: 
                          Image.network('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
                            fit: BoxFit.contain,
                          ),),
                          Text(
                            'Mr. Bulbasaur',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                        ]
                      ),
                    ),
                    const SizedBox(height: 10),
                    _selectCandidateButton('Candidate No.1', is1Checked,
                                            (val) {setState(() => is1Checked = val!);}),
                    ],
                  ),
                  
                  const SizedBox(width: 20),

                  Column(
                    children: [
                      Container(width: 180,height: 180,color: Colors.red[200],
                      child: Column(
                        children: [
                          Expanded(child: 
                          Image.network('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
                            fit: BoxFit.contain,
                          ),),
                          Text(
                            'Mr.Charmander',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                        ]
                      ),
                    ),
                    const SizedBox(height: 10),
                    _selectCandidateButton('Candidate No.2', is2Checked,
                                            (val) {setState(() => is2Checked = val!);}),
                    ],
                  ),

                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Column(
                    children: [
                      Container(width: 180,height: 180,color: Colors.blue[50],
                      child: Column(
                        children: [
                          Expanded(child: 
                          Image.network('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
                            fit: BoxFit.contain,
                          ),),
                          Text(
                            'Mr.Squirtle',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                        ]
                      ),
                    ),
                    const SizedBox(height: 10),
                    _selectCandidateButton('Candidate No.3', is3Checked,
                                            (val) {setState(() => is3Checked = val!);}),
                    ],
                  ),

                  const SizedBox(width: 20),

                  Column(
                    children: [
                      Container(width: 180,height: 180,color: Colors.yellow,
                      child: Column(
                        children: [
                          Expanded(child: 
                          Image.network('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
                            fit: BoxFit.contain,
                          ),),
                          Text(
                            'Mr.Pikachu',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                        ]
                      ),
                    ),
                    const SizedBox(height: 10),
                    _selectCandidateButton('Candidate No.4', is4Checked,
                                            (val) {setState(() => is4Checked = val!);}
                                            ),
                    ],
                  ),

                ],
              ),

              // SizedBox(height: 20),

              _comfirmCandidateButton('Confirm'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _comfirmCandidateButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _selectCandidateButton(String label, bool option, Function(bool?) onChanged){
    return SizedBox(
      width:180,
      child:CheckboxListTile(
          title: Text(label, style: const TextStyle(fontSize: 16)),
          value: option,
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          contentPadding: EdgeInsets.all(8),
          onChanged: onChanged,
        )
    );
  }
}


