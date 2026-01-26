import 'dart:convert';
import 'package:frontend/Models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String baseURL = 'http://10.0.2.2:3000/MyTasks/tasks';

  Future<List<TaskModel>> fetchTasks(String userEmail, String token) async {
    final url = Uri.parse('$baseURL/$userEmail');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final taskBody = jsonDecode(response.body);
      final tasks = taskBody['data'] as List;
      return tasks.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception('${errorBody['message']}');
    }
  }

  Future<void> addTask(TaskModel task, String token) async {
    final url = Uri.parse(baseURL);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode != 201) {
      final errorBody = jsonDecode(response.body);
      throw Exception('${errorBody['message']}');
    }
  }

  Future<void> updateTask(TaskModel task, String token) async {
    final url = Uri.parse('$baseURL/${task.uniqueId}');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception('${errorBody['message']}');
    }
  }

  Future<void> deleteTask(String uniqueId, String token) async {
    final url = Uri.parse('$baseURL/$uniqueId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception('${errorBody['message']}');
    }
  }
}
