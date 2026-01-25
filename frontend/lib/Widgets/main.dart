import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
import 'package:frontend/Widgets/flow_form_field.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowChangePasswordModal extends ConsumerWidget {
  const FlowChangePasswordModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final userEmail = ref
        .watch(prefProvider)
        .maybeWhen(
          data: (prefs) => prefs.getString('userEmail') ?? '',
          orElse: () => '',
        );

    final userController = userEmail.isNotEmpty
        ? ref.watch(fetchuserProvider(userEmail))
        : const AsyncValue<UserModel>.loading();

    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20.r),
          children: [
            Text(
              'Change Password',
              style: GoogleFonts.inter(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
            20.verticalSpace,
            FlowFormField(
              labelText: 'Old Password',
              hintText: 'Enter your Old password',
              controller: oldPasswordController,
              isPassword: true,
            ),
            20.verticalSpace,
            FlowFormField(
              labelText: 'New Password',
              hintText: 'Enter your New password',
              controller: newPasswordController,
              isPassword: true,
            ),
            20.verticalSpace,
            FlowFormField(
              labelText: 'Confirm Password',
              hintText: 'Enter your Confirm password',
              controller: confirmPasswordController,
              isPassword: true,
            ),
            20.verticalSpace,
            FlowAuthButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New passwords do not match'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Verify old password by attempting to login
                    await ref
                        .read(userServiceProvider)
                        .loginUser(userEmail, oldPasswordController.text);

                    // If login successful, proceed to update password
                    userController.maybeWhen(
                      data: (user) async {
                        await ref.read(userProvider.future).then((value) {
                          value.updateUser(
                            user.copyWith(password: newPasswordController.text),
                          );
                        });
                        if (context.mounted) Navigator.pop(context);
                      },
                      orElse: () {},
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Old password is incorrect'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              text: 'Save',
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
