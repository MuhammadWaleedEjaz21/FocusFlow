import 'package:flutter_riverpod/legacy.dart';

final categorySelectionProvider = StateProvider((ref) => 'all');

final List<String> categories = [
  'All',
  'Work',
  'Personal',
  'Shopping',
  'Health',
  'Finance',
  'Education',
];
