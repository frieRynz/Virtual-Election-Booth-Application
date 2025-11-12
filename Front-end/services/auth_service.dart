import 'dart:convert';
import 'package:http/http.dart' as http;
import '/services/storage_service.dart';

class AuthService {
  // Use http://127.0.0.1:5000 for web/iOS or http://10.0.2.2:5000 for Android
  final String _baseUrl = "http://10.0.2.2:5000"; 
  
  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', 
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String token = responseBody['access_token'];
      
      await _storageService.saveToken(token);
      
      return responseBody;
    } else {
      throw Exception(responseBody['error']);
    }
  }

  Future<Map<String, dynamic>> submitVote(int candidateId) async {

    String? token = await _storageService.getToken();

    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/vote'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

        'Authorization': 'Bearer $token', 
      },
      body: jsonEncode(<String, dynamic>{
        'Candidate_ID': candidateId,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception(responseBody['error']);
    }
  }

  Future<Map<String, dynamic>> registerUser(String nationalId, String phoneNo, String dob) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'National_ID': nationalId,
        'Phone_no': phoneNo,
        'DOB': dob, 
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception(responseBody['error']);
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String nationalId, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify_otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'National_ID': nationalId,
        'otp': otp,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 201) { 
      return responseBody;
    } else {
      throw Exception(responseBody['error']);
    }
  }
}