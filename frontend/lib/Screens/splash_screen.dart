import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/screen_navigation_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(userProvider, (previous, next) {
      next.when(
        data: (_) {
          final screenIndex = ref.read(screenNavigationProvider);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    screens(context)[screenIndex].screenWidget,
              ),
            );
          });
        },
        error: (error, stackTrace) {},
        loading: () {},
      );
    });

    return Center(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorLight,
            ],
            stops: const [0, 0.5, 1],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'FocusFlow',
              style: GoogleFonts.inter(
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            30.verticalSpace,
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
