import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/color_scheme_provider.dart';
import 'package:frontend/Providers/lang_selection_provider.dart';
import 'package:frontend/Providers/push_notifications_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_app_bar.dart';
import 'package:frontend/Widgets/flow_change_password_model.dart';
import 'package:frontend/Widgets/flow_drawer.dart';
import 'package:frontend/Widgets/flow_edit_profile_modal.dart';
import 'package:frontend/Widgets/flow_gradient_button.dart';
import 'package:frontend/Widgets/flow_header.dart';
import 'package:frontend/Widgets/flow_setting_menu_section.dart';
import 'package:frontend/Widgets/flow_switch_list_tile.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const FlowDrawer(),
      body: Column(
        children: [
          Expanded(
            child: FlowHeader(
              children: [
                30.verticalSpace,
                FlowAppBar(title: AppLocalizations.of(context)!.settings),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                children: [
                  30.verticalSpace,
                  const _AppearanceSection(),
                  20.verticalSpace,
                  const _NotificationSection(),
                  20.verticalSpace,
                  const _AccountSection(),
                  20.verticalSpace,
                  const _LanguageSection(),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.appearance.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            color: Colors.blueGrey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
        20.verticalSpace,
        FlowSettingMenuSection(
          children: [
            FlowSwitchListTile(
              title: AppLocalizations.of(context)!.darkMode,
              subtitle: AppLocalizations.of(context)!.disabled,
              value: isDark,
              onPressed: (value) async {
                ref.read(isDarkModeProvider.notifier).state = value;
                final prefs = await ref.read(prefProvider.future);
                prefs.setBool('isDarkMode', value);
              },
            ),
            10.verticalSpace,
            Divider(color: Theme.of(context).shadowColor, thickness: 1),
            10.verticalSpace,
            Center(
              child: Text(
                AppLocalizations.of(context)!.colorScheme,
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            20.verticalSpace,
            SizedBox(
              height: 50.h,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: lightschemes.length,
                separatorBuilder: (_, __) => 5.horizontalSpace,
                itemBuilder: (context, index) => FlowGradientButton(
                  colors: lightschemes[index].colors,
                  onPressed: () async {
                    ref.read(colorSchemeIndexProvider.notifier).state = index;
                    final prefs = await ref.read(prefProvider.future);
                    prefs.setInt('colorSchemeIndex', index);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationSection extends ConsumerWidget {
  const _NotificationSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotificationOn = ref.watch(isNotificationsInitializedProvider);
    final isSoundOn = ref.watch(isSoundOnProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.notification.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            color: Colors.blueGrey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
        20.verticalSpace,
        FlowSettingMenuSection(
          children: [
            FlowSwitchListTile(
              title: AppLocalizations.of(context)!.pushNotification,
              subtitle: AppLocalizations.of(
                context,
              )!.pushNotificationDescription,
              value: isNotificationOn,
              onPressed: (value) async {
                ref.read(isNotificationsInitializedProvider.notifier).state =
                    value;
                final prefs = await ref.read(prefProvider.future);
                prefs.setBool('isNotificationsInitialized', value);
              },
            ),
            FlowSwitchListTile(
              title: AppLocalizations.of(context)!.sound,
              subtitle: AppLocalizations.of(context)!.playSound,
              value: isSoundOn,
              onPressed: (value) async {
                ref.read(isSoundOnProvider.notifier).state = value;
                final prefs = await ref.read(prefProvider.future);
                prefs.setBool('isSoundOn', value);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _AccountSection extends ConsumerWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref
        .watch(prefProvider)
        .maybeWhen(
          data: (prefs) => prefs.getBool('isLoggedIn') ?? false,
          orElse: () => false,
        );

    if (!isLoggedIn) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.account.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            color: Colors.blueGrey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
        20.verticalSpace,
        FlowSettingMenuSection(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const FlowEditProfileModal(),
                );
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.person_outline,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                AppLocalizations.of(context)!.profile,
                style: GoogleFonts.inter(
                  fontSize: 20.r,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            10.verticalSpace,
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const FlowChangePasswordModal(),
                );
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.lock_outline,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                AppLocalizations.of(context)!.changePassword,
                style: GoogleFonts.inter(
                  fontSize: 20.r,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            10.verticalSpace,
          ],
        ),
      ],
    );
  }
}

class _LanguageSection extends ConsumerWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.appSettings,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            color: Colors.blueGrey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
        20.verticalSpace,
        FlowSettingMenuSection(
          children: [
            ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    height: 200,
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.language,
                          style: GoogleFonts.inter(
                            fontSize: 20.r,
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        20.verticalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: langSelectionList.entries.map((e) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(e.key),
                              onPressed: () async {
                                ref.read(langSelectionProvider.notifier).state =
                                    e.value;
                                final prefs = await ref.read(
                                  prefProvider.future,
                                );
                                prefs.setString('lang', e.value);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.language_outlined,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                AppLocalizations.of(context)!.language,
                style: GoogleFonts.inter(
                  fontSize: 20.r,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
