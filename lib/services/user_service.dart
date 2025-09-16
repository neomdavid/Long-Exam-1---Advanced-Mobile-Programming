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
    // Some API responses (e.g., login) return `{ token, user: { ... } }`
    // while others (e.g., register/get user) return the user object directly.
    final Map<String, dynamic> user = (userData['user'] is Map<String, dynamic>)
        ? userData['user']
        : userData;

    // Persist token if present at the top level
    await prefs.setString('token', userData['token']?.toString() ?? '');

    await prefs.setString('firstName', user['firstName']?.toString() ?? '');
    await prefs.setString('lastName', user['lastName']?.toString() ?? '');
    await prefs.setString('email', user['email']?.toString() ?? '');
    await prefs.setString('username', user['username']?.toString() ?? '');
    await prefs.setString('type', user['type']?.toString() ?? '');
    // Resolve userId from both top-level payload and nested user object
    final dynamic resolvedUserId = userData['userId'] ??
        userData['uid'] ??
        userData['_id'] ??
        userData['id'] ??
        user['_id'] ??
        user['id'] ??
        user['userId'] ??
        user['uid'];
    await prefs.setString('userId', resolvedUserId?.toString() ?? '');
    await prefs.setString('age', user['age']?.toString() ?? '');
    await prefs.setString('gender', user['gender']?.toString() ?? '');
    await prefs.setString(
        'contactNumber', user['contactNumber']?.toString() ?? '');
    await prefs.setString('address', user['address']?.toString() ?? '');
    await prefs.setBool('isActive', user['isActive'] == true);
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
      'age': prefs.getString('age') ?? '',
      'gender': prefs.getString('gender') ?? '',
      'contactNumber': prefs.getString('contactNumber') ?? '',
      'address': prefs.getString('address') ?? '',
      'isActive': prefs.getBool('isActive') ?? false,
    };
  }

  /// **Check if User is Logged In**
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  /// **Fetch User Profile from API using userId**
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    print('Fetching user profile for ID: $userId');
    print('API URL: $host/api/users/$userId');

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await get(
      Uri.parse('$host/api/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    print('User profile response status code: ${response.statusCode}');
    print('User profile response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Failed to fetch user profile: ${response.statusCode} - ${response.body}');
    }
  }

  /// **Fetch Current User Profile using token**
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUserId = prefs.getString('userId');
    final String? token = prefs.getString('token');

    if (savedUserId == null || savedUserId.isEmpty) {
      // No saved userId; cannot fetch profile
      throw Exception('No saved userId found');
    }

    print('Fetching user profile for ID: $savedUserId');
    print('API URL: $host/api/users/$savedUserId');

    final response = await get(
      Uri.parse('$host/api/users/$savedUserId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    print('User profile response status code: ${response.statusCode}');
    print('User profile response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Failed to fetch user profile: ${response.statusCode} - ${response.body}');
    }
  }

  /// **Logout and Clear User Data**
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
