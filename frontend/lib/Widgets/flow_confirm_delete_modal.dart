import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
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
              'Delete Account',
              style: GoogleFonts.inter(
                fontSize: 20.r,
                color: Theme.of(context).hintColor,
              ),
            ),
            20.verticalSpace,
            Text(
              'Are you sure you want to delete your account?',
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
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              text: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
