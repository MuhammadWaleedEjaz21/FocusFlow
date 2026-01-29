import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/color_scheme_provider.dart';
import 'package:frontend/Providers/lang_selection_provider.dart';
import 'package:frontend/Providers/push_notifications_provider.dart';
import 'package:frontend/Screens/splash_screen.dart';
import 'package:frontend/Services/localdb_service.dart';
import 'package:frontend/Services/push_notification_service.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await localDBInitialize();
  await initializeNotifications();

  final isDark = prefs.getBool('isDarkMode') ?? false;
  final schemeIndex = prefs.getInt('colorSchemeIndex') ?? 0;
  final lang = prefs.getString('lang') ?? 'en';
  final isNotificationOn = prefs.getBool('isNotificationsInitialized') ?? false;
  final isSoundOn = prefs.getBool('isSoundOn') ?? true;

  runApp(
    ProviderScope(
      overrides: [
        isDarkModeProvider.overrideWith((ref) => isDark),
        colorSchemeIndexProvider.overrideWith((ref) => schemeIndex),
        langSelectionProvider.overrideWith((ref) => lang),
        isNotificationsInitializedProvider.overrideWith(
          (ref) => isNotificationOn,
        ),
        isSoundOnProvider.overrideWith((ref) => isSoundOn),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(langSelectionProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final schemeIndex = ref.watch(colorSchemeIndexProvider);

    return ScreenUtilInit(
      designSize: const Size(447, 875),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        locale: Locale(lang),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'FocusFlow',
        theme: lightTheme[schemeIndex],
        darkTheme: darkTheme[schemeIndex],
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
