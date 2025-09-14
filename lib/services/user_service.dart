import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UserService {
  Map<String, dynamic> data = {};

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    print('Attempting login to: $host/api/users/login');
    print('Host value: $host');

    final response = await post(
      Uri.parse('$host/api/users/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Login failed: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String age,
    required String gender,
    required String contactNumber,
    required String email,
    required String username,
    required String password,
    required String address,
    required String type,
  }) async {
    final response = await post(
      Uri.parse('$host/api/users'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'contactNumber': contactNumber,
        'email': email,
        'username': username,
        'password': password,
        'address': address,
        'type': type,
      }),
    );

    print('Registration response status code: ${response.statusCode}');
    print('Registration response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Registration failed: ${response.statusCode} - ${response.body}');
    }
  }

  /// **Save User Data to SharedPreferences**
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', userData['firstName']?.toString() ?? '');
    await prefs.setString('lastName', userData['lastName']?.toString() ?? '');
    await prefs.setString('email', userData['email']?.toString() ?? '');
    await prefs.setString('username', userData['username']?.toString() ?? '');
    await prefs.setString('token', userData['token']?.toString() ?? '');
    await prefs.setString('type', userData['type']?.toString() ?? '');
    await prefs.setString('userId', userData['_id']?.toString() ?? '');
  }

  /// **Retrieve User Data from SharedPreferences**
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'email': prefs.getString('email') ?? '',
      'username': prefs.getString('username') ?? '',
      'token': prefs.getString('token') ?? '',
      'type': prefs.getString('type') ?? '',
      'userId': prefs.getString('userId') ?? '',
    };
  }

  /// **Check if User is Logged In**
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  /// **Logout and Clear User Data**
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
