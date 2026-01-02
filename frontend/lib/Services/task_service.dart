import 'dart:convert';
import 'package:frontend/Models/task_model.dart';
import 'package:http/http.dart' as http;

final localTaskList = <TaskModel>[];

class TaskService {
  final String baseURL = "http://10.0.2.2:3000/MyTasks/tasks";

  Future<void> fetchTasks(String userEmail) async {
    final url = Uri.parse('$baseURL/$userEmail');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      final List<dynamic> jsonData = jsonBody["data"];

      final data = jsonData.map((item) => TaskModel.fromJson(item)).toList();
      localTaskList.clear();
      localTaskList.addAll(data);
    } else if (response.statusCode == 404) {
      throw Exception('No Task');
    } else {
      throw Exception('Server error: Failed to load tasks');
    }
  }

  Future<void> addTask(TaskModel task) async {
    final url = Uri.parse(baseURL);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error["message"] ?? "Failed to add task");
    }
  }

  Future<void> deleteTask(String uniqueId) async {
    final url = Uri.parse('$baseURL/$uniqueId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error["message"] ?? "Failed to delete task");
    }
  }

  Future<void> updateTask(TaskModel task) async {
    final url = Uri.parse('$baseURL/${task.uniqueId}');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error["message"] ?? "Failed to update task");
    }
  }
}
