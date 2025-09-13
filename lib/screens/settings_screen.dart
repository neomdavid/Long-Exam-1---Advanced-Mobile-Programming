import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          'Settings',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
            child: CustomText(
              'Appearance',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => themeModel.toggleTheme(),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 4.h,
                ),
                title: CustomText(
                  'Dark Mode',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                trailing: IconButton(
                  onPressed: () => themeModel.toggleTheme(),
                  icon: Icon(
                    themeModel.isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Account section
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
            child: CustomText(
              'Account',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 4.h,
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 24.sp,
                ),
                title: CustomText(
                  'Logout',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            'Logout',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          content: CustomText(
            'Are you sure you want to logout?',
            fontSize: 14.sp,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CustomText(
                'Cancel',
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await UserService().logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: CustomText(
                'Logout',
                fontSize: 14.sp,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
