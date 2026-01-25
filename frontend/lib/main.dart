import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/color_scheme_provider.dart';
import 'package:frontend/Providers/screen_navigation_provider.dart';
import 'package:frontend/Services/push_notification_service.dart';
import 'package:frontend/Widgets/flow_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = SharedPreferences.getInstance();
    Future.microtask(() async {
      await prefs.then((sharedPrefs) {
        final isDark = sharedPrefs.getBool('isDarkMode') ?? false;
        ref.read(isDarkModeProvider.notifier).state = isDark;
      });
      await prefs.then((sharedPrefs) {
        final schemeIndex = sharedPrefs.getInt('colorSchemeIndex') ?? 0;
        ref.read(colorSchemeIndexProvider.notifier).state = schemeIndex;
      });
    });
    final isDark = ref.watch(isDarkModeProvider);
    final schemeIndex = ref.watch(colorSchemeIndexProvider);
    return ScreenUtilInit(
      designSize: Size(447, 875),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FocusFlow',
        theme: lightTheme[schemeIndex],
        darkTheme: darkTheme[schemeIndex],
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          key: scaffoldKey,
          drawer: FlowDrawer(),
          body: Consumer(
            builder: (context, ref, child) {
              final screenIndex = ref.watch(screenNavigationProvider);
              return screens[screenIndex].screenWidget;
            },
          ),
        ),
      ),
    );
  }
}
