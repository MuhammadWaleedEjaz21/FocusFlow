import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowSwitchListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function(bool) onPressed;
  final bool? value;
  const FlowSwitchListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value ?? false,
      onChanged: onPressed,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).hintColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey.shade600),
      ),
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey.shade300,
      activeThumbColor: Colors.white,
      activeTrackColor: Theme.of(context).primaryColor,
      trackOutlineColor: WidgetStatePropertyAll(Colors.white.withAlpha(0)),
    );
  }
}
