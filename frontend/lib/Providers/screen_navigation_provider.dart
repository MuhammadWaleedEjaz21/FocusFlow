import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/Models/screen_navigation_model.dart';
import 'package:frontend/Screens/home_screen.dart';
import 'package:frontend/Screens/setting_screen.dart';

final screenNavigationProvider = StateProvider((ref) => 0);
final List<ScreenNavigationModel> screens = [
  ScreenNavigationModel(
    screenName: 'Home',
    screenIcon: Icons.home,
    screenWidget: HomeScreen(),
  ),
  ScreenNavigationModel(
    screenName: 'Settings',
    screenIcon: Icons.settings,
    screenWidget: SettingScreen(),
  ),
];
