import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/Models/screen_navigation_model.dart';
import 'package:frontend/Screens/home_screen.dart';
import 'package:frontend/Screens/setting_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

final screenNavigationProvider = StateProvider((ref) => 0);
List<ScreenNavigationModel> screens(BuildContext context) => [
  ScreenNavigationModel(
    screenName: AppLocalizations.of(context)!.home,
    screenIcon: Icons.home,
    screenWidget: HomeScreen(),
  ),
  ScreenNavigationModel(
    screenName: AppLocalizations.of(context)!.settings,
    screenIcon: Icons.settings,
    screenWidget: SettingScreen(),
  ),
];
