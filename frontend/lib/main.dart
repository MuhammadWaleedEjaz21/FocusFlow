import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Config/app_dark_theme.dart';
import 'package:frontend/Config/app_light_theme.dart';
import 'package:frontend/Screens/home_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      child: HomeScreen(),
      builder: (context, child) => MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,  
        debugShowCheckedModeBanner: false,
        title: 'FocusFlow',
        home: child,
      ),
    );
  }
}
