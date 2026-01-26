import 'package:flutter_riverpod/legacy.dart';

final langSelectionProvider = StateProvider<String>((ref) => 'en');
final Map<String, String> langSelectionList = {
  'English': 'en',
  'Arabic': 'ar',
  'Urdu': 'ur',
  'Turkish': 'tr',
};
