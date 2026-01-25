import 'package:flutter/material.dart';

class ScreenNavigationModel {
  final String screenName;
  final IconData screenIcon;
  final Widget screenWidget;

  ScreenNavigationModel({
    required this.screenName,
    required this.screenIcon,
    required this.screenWidget,
  });
}
