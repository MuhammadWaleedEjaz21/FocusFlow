import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/Models/color_schemes_model.dart';
import 'package:frontend/Themes/dark_themes.dart';
import 'package:frontend/Themes/light_themes.dart';

final colorSchemeIndexProvider = StateProvider((ref) => 0);
final isDarkModeProvider = StateProvider<bool>((ref) => false);

List<ColorSchemesModel> lightschemes = [
  ColorSchemesModel(
    colors: [Colors.deepPurple, Colors.deepPurple, Colors.purple],
  ),
  ColorSchemesModel(colors: [Colors.blue, Colors.blue, Colors.lightBlue]),
  ColorSchemesModel(colors: [Colors.green, Colors.green, Colors.lightGreen]),
  ColorSchemesModel(colors: [Colors.orange, Colors.orange, Colors.deepOrange]),
];
List<ThemeData> lightTheme = [
  lightPurpleTheme,
  lightBlueTheme,
  lightGreenTheme,
  lightOrangeTheme,
];
List<ThemeData> darkTheme = [
  darkPurpleTheme,
  darkBlueTheme,
  darkGreenTheme,
  darkOrangeTheme,
];
