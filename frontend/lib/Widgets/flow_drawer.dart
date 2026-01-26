import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/screen_navigation_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Screens/login_screen.dart';
import 'package:frontend/Screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/l10n/app_localizations.dart';

class FlowDrawer extends ConsumerWidget {
  const FlowDrawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSelection = ref.watch(screenNavigationProvider);
    final isLoggedIn = ref
        .watch(prefProvider)
        .maybeWhen(
          data: (prefs) => prefs.getBool('isLoggedIn') ?? false,
          orElse: () => false,
        );
    final userEmail = ref
        .watch(prefProvider)
        .maybeWhen(
          data: (prefs) => prefs.getString('userEmail') ?? '',
          orElse: () => '',
        );
    final userAsync = ref.watch(fetchuserProvider(userEmail));
    final userData = userAsync.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                stops: [0, 0.5, 1],
              ),
            ),
            child: isLoggedIn
                ? Column(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 80.r,
                        color: Colors.white,
                      ),
                      if (userAsync.isLoading)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        Flexible(
                          child: Text(
                            userData?.fullName ?? 'Guest',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(150.w, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                          textStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.login),
                      ),
                      10.verticalSpace,
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(150.w, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                          textStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.signUp),
                      ),
                    ],
                  ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: screens(context).length,
            itemBuilder: (context, index) => FlowDrawerItem(
              title: screens(context)[index].screenName,
              icon: screens(context)[index].screenIcon,
              isSelected: screenSelection == index,
              onTap: () {
                ref.read(screenNavigationProvider.notifier).state = index;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screens(context)[index].screenWidget,
                  ),
                );
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: isLoggedIn
                ? ListTile(
                    tileColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    leading: Icon(
                      Icons.logout,
                      size: 30.r,
                      color: Colors.white,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.logout,
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      final controller = await ref.read(userProvider.future);
                      await controller.logoutUser();
                      Navigator.of(context).pop();
                    },
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class FlowDrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;
  const FlowDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: ListTile(
        tileColor: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(
            color: Theme.of(context).primaryColor.withAlpha(75),
            width: 2,
          ),
        ),
        leading: Icon(
          icon,
          size: 30.r,
          color: isSelected ? Colors.white : Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
