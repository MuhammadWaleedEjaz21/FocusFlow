import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/category_status_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCategoryButton extends ConsumerWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  const CustomCategoryButton({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.read(categorySelectionProvider.notifier);
    return TextButton.icon(
      onPressed: () {
        category.state = title.toLowerCase();
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? Colors.white
            : Theme.of(
                context,
              ).textButtonTheme.style!.foregroundColor!.resolve({}),
        backgroundColor: isSelected
            ? Colors.deepPurple
            : Theme.of(context).highlightColor,
        shadowColor: Theme.of(context).shadowColor,
        elevation: isSelected ? 5.r : 0.r,
      ),
      label: Text(title, style: GoogleFonts.inter(fontSize: 17.5.sp)),
      icon: Icon(icon, size: 20.r),
    );
  }
}
