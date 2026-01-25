import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Screens/signup_screen.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
import 'package:frontend/Widgets/flow_form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                child: Icon(Icons.login, size: 80.r, color: Colors.white),
              ),
              20.verticalSpace,
              Text(
                'Welcome Back!',
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                ),
              ),
              5.verticalSpace,
              Text(
                'Sign in to continue',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  color: Colors.blueGrey.shade600,
                ),
              ),
              30.verticalSpace,
              Form(
                child: Container(
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
                    key: _formKey,
                    child: Column(
                      children: [
                        FlowFormField(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                          controller: _emailController,
                        ),
                        30.verticalSpace,
                        FlowFormField(
                          labelText: 'Password',
                          hintText: '.......',
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                              ),
                              child: Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        30.verticalSpace,
                        Row(
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final pref = SharedPreferences.getInstance();
                                return FlowAuthButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        final controller = await ref.read(
                                          userProvider.future,
                                        );

                                        final token = await controller
                                            .loginUser(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );

                                        final prefs = await pref;
                                        await prefs.setString(
                                          'authToken',
                                          token,
                                        );
                                        await prefs.setString(
                                          'userEmail',
                                          _emailController.text.trim(),
                                        );
                                        await prefs.setBool('isLoggedIn', true);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Login Successful!',
                                                style: GoogleFonts.inter(
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                e.toString().split(': ')[1],
                                                style: GoogleFonts.inter(
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  text: 'Login',
                                );
                              },
                            ),
                          ],
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).hintColor,
                                fontSize: 20.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                textStyle: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
