import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Screens/reset_password_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
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
                AppLocalizations.of(context)!.enterVerificationCode,
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                ),
              ),
              5.verticalSpace,
              Text(
                AppLocalizations.of(context)!.enterVerificationCodeDescription,
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
                      OtpTextField(
                        numberOfFields: 6,
                        showFieldAsBox: true,
                        onSubmit: (value) async {
                          try {
                            final controller = await ref.read(
                              userProvider.future,
                            );
                            controller.verifyOTP(widget.email, value);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResetPasswordScreen(email: widget.email),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
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
