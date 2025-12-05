import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/category_status_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStatusButton extends ConsumerWidget {
  final String title;
  final bool isSelected;
  const CustomStatusButton({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusSelection = ref.read(statusSelectionProvider.notifier);
    return Expanded(
      child: TextButton(
        onPressed: () {
          statusSelection.state = title.toLowerCase();
        },
        style: TextButton.styleFrom(
          foregroundColor: isSelected
              ? Colors.deepPurple
              : Theme.of(
                  context,
                ).textButtonTheme.style!.foregroundColor!.resolve({}),
          backgroundColor: isSelected
              ? Theme.of(
                  context,
                ).textButtonTheme.style!.backgroundColor!.resolve({})
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          shadowColor: isSelected ? Theme.of(context).shadowColor : null,
          elevation: isSelected ? 5.r : 0.r,
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
