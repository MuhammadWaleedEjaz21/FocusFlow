import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.purple, Colors.deepPurple],
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 50.r, color: Colors.white),
                Text(
                  "Waleed Ejaz",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ListTile(
              textColor: Colors.deepPurple,
              iconColor: Colors.deepPurple,
              selectedColor: Colors.white,

              selectedTileColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              tileColor: Colors.deepPurple.shade50,
              leading: Icon(Icons.home_outlined, size: 30.r),
              title: Text(
                "Home",
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ListTile(
              textColor: Colors.deepPurple,
              iconColor: Colors.deepPurple,
              selectedTileColor: Colors.deepPurple,
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              tileColor: Colors.deepPurple.shade50,
              leading: Icon(Icons.settings_outlined, size: 30.r),
              title: Text(
                "Settings",
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          450.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ListTile(
              textColor: Colors.red,
              iconColor: Colors.red,
              selectedTileColor: Colors.red,
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              tileColor: Colors.red.shade50,
              leading: Icon(Icons.logout_outlined, size: 30.r),
              title: Text(
                "Logout",
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
