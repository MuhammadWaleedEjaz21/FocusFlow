import 'dart:convert';
import 'package:frontend/Models/user_model.dart';
import 'package:http/http.dart' as http;

typedef TokenRefreshCallback = Future<String> Function();

class UserService {
  final String baseUrl =
      'https://focusflow-production-dc7a.up.railway.app/MyTasks/users';

  TokenRefreshCallback? onTokenExpired;

  Future<UserModel> fetchUserData(String email, String token) async {
    final url = Uri.parse('$baseUrl/$email');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      if (onTokenExpired != null) {
        try {
          final newToken = await onTokenExpired!();
          final retryResponse = await http.get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
          );
          if (retryResponse.statusCode == 200) {
            final userBody = jsonDecode(retryResponse.body);
            return UserModel.fromJson(userBody['data']);
          }
        } catch (e) {
          throw Exception('Token refresh failed: $e');
        }
      }
      throw Exception('Token expired');
    }

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

    if (response.statusCode == 401) {
      if (onTokenExpired != null) {
        try {
          final newToken = await onTokenExpired!();
          final retryResponse = await http.patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
            body: jsonEncode(user.toJson()),
          );
          if (retryResponse.statusCode != 200) {
            throw Exception('${jsonDecode(retryResponse.body)['message']}');
          }
          return;
        } catch (e) {
          throw Exception('Token refresh failed: $e');
        }
      }
      throw Exception('Token expired');
    }

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

    if (response.statusCode == 401) {
      if (onTokenExpired != null) {
        try {
          final newToken = await onTokenExpired!();
          final retryResponse = await http.delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
          );
          if (retryResponse.statusCode != 200) {
            throw Exception('${jsonDecode(retryResponse.body)['message']}');
          }
          return;
        } catch (e) {
          throw Exception('Token refresh failed: $e');
        }
      }
      throw Exception('Token expired');
    }

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

  Future<Map<String, String>> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return {
        'accessToken': responseBody['accessToken'] ?? '',
        'refreshToken': responseBody['refreshToken'] ?? '',
      };
    } else {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    final url = Uri.parse('$baseUrl/refresh-token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['accessToken'] ?? '';
    } else {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  Future<void> logoutUser(String email) async {
    final url = Uri.parse('$baseUrl/logout');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
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
