import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/pages/home_screen.dart';

class VotingPage extends StatefulWidget {
  final int voterId;
  const VotingPage({
    super.key,
    required this.voterId,
  });

  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
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
                      MaterialPageRoute(builder: (_) => HomeScreen()),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cast Your Vote'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const CircularProgressIndicator() 
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCandidateButton('Candidate No.1', 1),
                        const SizedBox(width: 20),
                        _buildCandidateButton('Candidate No.2', 2),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCandidateButton('Candidate No.3', 3),
                        const SizedBox(width: 20),
                        _buildCandidateButton('Candidate No.4', 4),
                      ],
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCandidateButton(String label, int candidateId) {
    return ElevatedButton(
      onPressed: () => _handleVote(candidateId),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}