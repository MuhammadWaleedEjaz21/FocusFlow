import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final passwordVisibilityNotifier = StateProvider<bool>((ref) => false);

class FlowFormField extends ConsumerWidget {
  final String labelText;
  final String hintText;
  final bool? isPassword;
  final TextEditingController controller;
  final int? maxLines;

  const FlowFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = ref.watch(passwordVisibilityNotifier);
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: isPassword!
                ? TextInputType.visiblePassword
                : TextInputType.text,
            controller: controller,
            maxLines: maxLines,
            obscureText: isPassword! ? !isPasswordVisible : false,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: Theme.of(context).hintColor,
            ),
            obscuringCharacter: '•',
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              labelStyle: GoogleFonts.inter(
                color: Theme.of(context).primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: GoogleFonts.inter(color: Theme.of(context).hintColor),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              if (isPassword! && value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              if (labelText == 'Email' &&
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              if (isPassword! &&
                  labelText == 'Confirm Password' &&
                  value != controller.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
        isPassword!
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  size: 24.r,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  ref.read(passwordVisibilityNotifier.notifier).state =
                      !isPasswordVisible;
                },
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
