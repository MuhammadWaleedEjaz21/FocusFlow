class TaskModel {
  final String userEmail;
  final String uniqueId;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isFavorite;

  TaskModel({
    required this.userEmail,
    required this.uniqueId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    this.isFavorite = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final userEmail = json['userEmail'];
    final uniqueId = json['uniqueId'];
    final title = json['title'];
    final description = json['description'];
    final category = json['category'];
    final priority = json['priority'];
    final dueDate = json['dueDate'];

    if (userEmail == null ||
        uniqueId == null ||
        title == null ||
        description == null ||
        category == null ||
        priority == null ||
        dueDate == null) {
      throw FormatException('Missing required fields in TaskModel JSON: $json');
    }

    return TaskModel(
      userEmail: userEmail as String,
      uniqueId: uniqueId as String,
      title: title as String,
      description: description as String,
      category: category as String,
      priority: priority as String,
      dueDate: DateTime.parse(dueDate as String),
      isCompleted: json['isCompleted'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
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
      'isFavorite': isFavorite,
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
    bool? isFavorite,
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
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
