import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
import 'package:frontend/Widgets/flow_form_field.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(Icons.lock_open, size: 80.r, color: Colors.white),
              ),
              20.verticalSpace,
              Text(
                'Reset Password',
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                ),
              ),
              5.verticalSpace,
              Text(
                'Enter your new password',
                style: GoogleFonts.inter(
                  fontSize: 17.5.sp,
                  color: Colors.blueGrey.shade600,
                ),
              ),
              20.verticalSpace,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(30.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 5.r,
                      blurRadius: 10.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: Form(
                  child: Column(
                    children: [
                      FlowFormField(
                        labelText: 'New Password',
                        hintText: '********',
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      30.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: FlowAuthButton(
                              onPressed: () async {
                                try {
                                  final controller = await ref.read(
                                    userProvider.future,
                                  );
                                  controller.resetPassword(
                                    widget.email,
                                    _passwordController.text,
                                  );
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                              text: 'Reset Password',
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
        ),
      ),
    );
  }
}
