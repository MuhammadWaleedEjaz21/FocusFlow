import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/color_scheme_provider.dart';
import 'package:frontend/Providers/push_notifications_provider.dart';
import 'package:frontend/Widgets/flow_app_bar.dart';
import 'package:frontend/Widgets/flow_gradient_button.dart';
import 'package:frontend/Widgets/flow_header.dart';
import 'package:frontend/Widgets/flow_setting_menu_section.dart';
import 'package:frontend/Widgets/flow_switch_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prefs = SharedPreferences.getInstance();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: FlowHeader(
              children: [
                30.verticalSpace,
                FlowAppBar(title: 'Settings'),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: ListView(
                children: [
                  Text(
                    'APPEARANCE',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      color: Colors.blueGrey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  20.verticalSpace,
                  FlowSettingMenuSection(
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final isDark = ref.watch(isDarkModeProvider);
                          return FlowSwitchListTile(
                            title: 'Dark Theme',
                            subtitle: 'Disabled',
                            value: isDark,
                            onPressed: (value) {
                              ref.read(isDarkModeProvider.notifier).state =
                                  value;
                              prefs.then((sharedPrefs) {
                                sharedPrefs.setBool('isDarkMode', value);
                              });
                            },
                          );
                        },
                      ),
                      10.verticalSpace,
                      Divider(
                        color: Theme.of(context).shadowColor,
                        thickness: 1,
                      ),
                      10.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Color Scheme',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          20.verticalSpace,
                          Consumer(
                            builder: (context, ref, child) {
                              return SizedBox(
                                height: 50.h,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => lightschemes
                                      .map(
                                        (e) => FlowGradientButton(
                                          colors: e.colors,
                                          onPressed: () {
                                            ref
                                                    .read(
                                                      colorSchemeIndexProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                index;
                                            prefs.then((sharedPrefs) {
                                              sharedPrefs.setInt(
                                                'colorSchemeIndex',
                                                index,
                                              );
                                            });
                                          },
                                        ),
                                      )
                                      .toList()[index],
                                  separatorBuilder: (context, index) =>
                                      5.horizontalSpace,
                                  itemCount: lightschemes.length,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Text(
                    'NOTIFICATIONS',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      color: Colors.blueGrey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      Future.microtask(() async {
                        await prefs.then((sharedPrefs) {
                          final isNotificationOn =
                              sharedPrefs.getBool(
                                'isNotificationsInitialized',
                              ) ??
                              false;
                          ref
                                  .read(
                                    isNotificationsInitializedProvider.notifier,
                                  )
                                  .state =
                              isNotificationOn;
                          final isSoundOn =
                              sharedPrefs.getBool('isSoundOn') ?? true;
                          ref.read(isSoundOnProvider.notifier).state =
                              isSoundOn;
                        });
                      });
                      final isNotificationOn = ref.watch(
                        isNotificationsInitializedProvider,
                      );
                      final isSoundOn = ref.watch(isSoundOnProvider);
                      return FlowSettingMenuSection(
                        children: [
                          FlowSwitchListTile(
                            title: 'Push Notification',
                            subtitle: 'Receive push notifications',
                            value: isNotificationOn,
                            onPressed: (value) async {
                              ref
                                      .read(
                                        isNotificationsInitializedProvider
                                            .notifier,
                                      )
                                      .state =
                                  value;
                              await prefs.then((sharedPrefs) {
                                sharedPrefs.setBool(
                                  'isNotificationsInitialized',
                                  value,
                                );
                              });
                            },
                          ),
                          FlowSwitchListTile(
                            title: 'Sound',
                            subtitle: 'Play notification sounds',
                            value: isSoundOn,
                            onPressed: (value) {
                              ref.read(isSoundOnProvider.notifier).state =
                                  value;
                              prefs.then((sharedPrefs) {
                                sharedPrefs.setBool('isSoundOn', value);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  20.verticalSpace,
                  Text(
                    'ACCOUNT',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      color: Colors.blueGrey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FlowSettingMenuSection(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.person_outline,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          'Edit Profile',
                          style: GoogleFonts.inter(
                            fontSize: 20.r,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.lock_outline,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          'Change Password',
                          style: GoogleFonts.inter(
                            fontSize: 20.r,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.language_outlined,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          'Language',
                          style: GoogleFonts.inter(
                            fontSize: 20.r,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
