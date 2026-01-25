import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/status_selection_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowStatusButton extends ConsumerWidget {
  final String title;
  const FlowStatusButton({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusSelection = ref.watch(statusSelectionProvider);
    final isSelected = statusSelection == title.toLowerCase();
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          ref.read(statusSelectionProvider.notifier).state = title
              .toLowerCase();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: isSelected
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white.withAlpha(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
