import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';
import '../widgets/theme_icons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          'Settings',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: CustomText(
              'Appearance',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => themeModel.toggleTheme(),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: CustomText(
                  'Dark Mode',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                trailing: IconButton(
                  onPressed: () => themeModel.toggleTheme(),
                  icon: ThemedIcon(
                    themeModel.isDark
                        ? ThemeIcons.darkMode
                        : ThemeIcons.lightMode,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Account section
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: CustomText(
              'Account',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: ThemedIcon(
                  ThemeIcons.logout,
                  color: Colors.red,
                  size: 24,
                  useThemeColor: false,
                ),
                title: CustomText(
                  'Logout',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
                trailing: ThemedIcon(
                  ThemeIcons.forward,
                  size: 16,
                  color: Colors.grey,
                  useThemeColor: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: CustomText(
            'Are you sure you want to logout?',
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CustomText(
                'Cancel',
                fontSize: 14,
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
                fontSize: 14,
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
