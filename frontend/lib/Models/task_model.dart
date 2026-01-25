class TaskModel {
  final String userEmail;
  final String uniqueId;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime dueDate;
  final bool isCompleted;

  TaskModel({
    required this.userEmail,
    required this.uniqueId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      userEmail: json['userEmail'],
      uniqueId: json['uniqueId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      priority: json['priority'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'uniqueId': uniqueId,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  TaskModel copyWith({
    String? userEmail,
    String? uniqueId,
    String? title,
    String? description,
    String? category,
    String? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      userEmail: userEmail ?? this.userEmail,
      uniqueId: uniqueId ?? this.uniqueId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
