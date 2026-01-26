import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
import 'package:frontend/Widgets/flow_form_field.dart';
import 'package:frontend/l10n/app_localizations.dart';
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
              AppLocalizations.of(context)!.changePassword,
              style: GoogleFonts.inter(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
            20.verticalSpace,
            FlowFormField(
              labelText: AppLocalizations.of(context)!.oldPassword,
              hintText: AppLocalizations.of(context)!.oldPassworddescription,
              controller: oldPasswordController,
              isPassword: true,
            ),
            20.verticalSpace,
            FlowFormField(
              labelText: AppLocalizations.of(context)!.newPassword,
              hintText: AppLocalizations.of(context)!.newPassworddescription,
              controller: newPasswordController,
              isPassword: true,
            ),
            20.verticalSpace,
            FlowFormField(
              labelText: AppLocalizations.of(context)!.confirmNewPassword,
              hintText: AppLocalizations.of(
                context,
              )!.confirmNewPassworddescription,
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
                    await ref
                        .read(userServiceProvider)
                        .loginUser(userEmail, oldPasswordController.text);
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
              text: AppLocalizations.of(context)!.save,
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
