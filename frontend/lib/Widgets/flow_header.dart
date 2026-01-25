import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlowHeader extends StatelessWidget {
  final List<Widget> children;
  const FlowHeader({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.r),
        bottomRight: Radius.circular(30.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            stops: [0, 0.5, 1],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
