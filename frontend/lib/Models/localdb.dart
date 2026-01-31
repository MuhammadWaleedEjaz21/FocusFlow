import 'package:hive/hive.dart';

part 'localdb.g.dart';

@HiveType(typeId: 0)
class LocalDB extends HiveObject {
  @HiveField(0)
  late final String userEmail;
  @HiveField(1)
  late final String uniqueId;
  @HiveField(2)
  late final String title;
  @HiveField(3)
  late final String description;
  @HiveField(4)
  late final String category;
  @HiveField(5)
  late final String priority;
  @HiveField(6)
  late final DateTime dueDate;
  @HiveField(7)
  late final bool isCompleted;
  @HiveField(8)
  late final bool isFavorite;
  @HiveField(9)
  bool isPendingSync = false;
}
