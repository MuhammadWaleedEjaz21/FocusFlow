import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
import 'package:frontend/Widgets/flow_form_field.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowEditProfileModal extends ConsumerWidget {
  const FlowEditProfileModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final userEmail = ref
        .watch(prefProvider)
        .maybeWhen(
          data: (value) {
            return value.getString('userEmail') ?? '';
          },
          orElse: () {
            return '';
          },
        );
    final userController = ref.watch(fetchuserProvider(userEmail));
    userController.maybeWhen(
      data: (user) {
        nameController.text = user.fullName;
      },
      orElse: () {},
    );

    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(20.r),
        children: [
          Text(
            AppLocalizations.of(context)!.profile,
            style: GoogleFonts.inter(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).hintColor,
            ),
          ),
          20.verticalSpace,
          FlowFormField(
            labelText: AppLocalizations.of(context)!.newName,
            hintText: AppLocalizations.of(context)!.newNamedescription,
            controller: nameController,
          ),
          20.verticalSpace,
          FlowAuthButton(
            onPressed: () async {
              final userController = ref.watch(fetchuserProvider(userEmail));
              userController.maybeWhen(
                data: (user) async {
                  await ref.read(userProvider.future).then((value) {
                    value.updateUser(
                      user.copyWith(fullName: nameController.text),
                    );
                  });
                },
                orElse: () {},
              );
              Navigator.pop(context);
            },
            text: AppLocalizations.of(context)!.save,
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
