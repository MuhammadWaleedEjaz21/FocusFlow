import 'dart:convert';
import 'package:frontend/Models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://10.0.2.2:3000/MyTasks/users';

  Future<UserModel> fetchUserData(String email, String token) async {
    final url = Uri.parse('$baseUrl/$email');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final userBody = jsonDecode(response.body);
      return UserModel.fromJson(userBody['data']);
    } else {
      throw Exception(
        '${jsonDecode(response.body)['message']} : ${response.statusCode} - ${jsonDecode(response.body)['error']}',
      );
    }
  }

  Future<void> updateUserData(UserModel user, String token) async {
    final url = Uri.parse('$baseUrl/${user.email}');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<void> deleteUser(String email, String token) async {
    final url = Uri.parse('$baseUrl/$email');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<void> registerUser(UserModel user) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<String> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['token'];
    } else {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<void> sendOTP(String email) async {
    final url = Uri.parse('$baseUrl/send-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userEmail': email}),
    );
    if (response.statusCode != 200) {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    final url = Uri.parse('$baseUrl/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userEmail': email, 'otp': otp}),
    );
    if (response.statusCode != 200) {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('$baseUrl/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userEmail': email, 'newPassword': newPassword}),
    );
    if (response.statusCode != 200) {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }
}
