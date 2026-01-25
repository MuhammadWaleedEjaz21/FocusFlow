import 'package:flutter_riverpod/legacy.dart';

final statusSelectionProvider = StateProvider((ref) => 'all');

final List<String> statuses = ['All', 'Active', 'Completed'];
