import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/catergory_selection_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowCategoryButton extends ConsumerWidget {
  final String title;
  const FlowCategoryButton({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(categorySelectionProvider);
    final isSelected = selectedCategory == title.toLowerCase();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: TextButton(
        onPressed: () {
          ref.read(categorySelectionProvider.notifier).state = title
              .toLowerCase();
        },
        style: TextButton.styleFrom(
          foregroundColor: isSelected
              ? Colors.white
              : Theme.of(context).primaryColor,
          textStyle: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
