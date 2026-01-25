import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Screens/login_screen.dart';
import 'package:frontend/Widgets/flow_auth_button.dart';
import 'package:frontend/Widgets/flow_form_field.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _fullNameController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fullNameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _confirmPasswordController.dispose();
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
                child: Icon(Icons.person_add, size: 80.r, color: Colors.white),
              ),
              20.verticalSpace,
              Text(
                'Create Account',
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                ),
              ),
              5.verticalSpace,
              Text(
                'Sign up to continue',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  color: Colors.blueGrey.shade600,
                ),
              ),
              30.verticalSpace,
              Form(
                key: _formKey,
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
                  child: Column(
                    children: [
                      FlowFormField(
                        labelText: 'Full Name',
                        hintText: 'John Doe',
                        controller: _fullNameController,
                      ),
                      30.verticalSpace,
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
                      30.verticalSpace,
                      FlowFormField(
                        labelText: 'Confirm Password',
                        hintText: '.......',
                        controller: _confirmPasswordController,
                        isPassword: true,
                      ),
                      30.verticalSpace,
                      Row(
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              return FlowAuthButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final user = UserModel(
                                        fullName: _fullNameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                      final controller = await ref.read(
                                        userProvider.future,
                                      );
                                      await controller.registerUser(user);

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Sign Up Successful!',
                                              style: GoogleFonts.inter(
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
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
                                text: 'Sign Up',
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
                            'Already have an account?',
                            style: GoogleFonts.inter(
                              color: Colors.blueGrey.shade600,
                              fontSize: 20.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
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
                            child: Text('Login'),
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
