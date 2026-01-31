import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowConfirmDeleteModal extends ConsumerWidget {
  const FlowConfirmDeleteModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20.r),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text(
              AppLocalizations.of(context)!.deleteAccount,
              style: GoogleFonts.inter(
                fontSize: 20.r,
                color: Theme.of(context).hintColor,
              ),
            ),
            20.verticalSpace,
            Text(
              AppLocalizations.of(context)!.deleteAccountDescription,
              style: GoogleFonts.inter(
                fontSize: 20.r,
                color: Theme.of(context).hintColor,
              ),
            ),
            20.verticalSpace,
            FlowAuthButton(
              onPressed: () async {
                try {
                  final prefs = await ref.read(prefProvider.future);
                  final email = prefs.getString('userEmail');
                  if (email != null) {
                    final controller = await ref.read(userProvider.future);
                    controller.deleteUser(email);
                  }
                  prefs.setBool('isLoggedIn', false);
                  ref.read(isLoggedInProvider.notifier).state = false;
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              text: AppLocalizations.of(context)!.delete,
            ),
          ],
        ),
      ),
    );
  }
}
