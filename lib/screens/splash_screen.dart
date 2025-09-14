import 'dart:async';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/custom_text.dart';
import '../widgets/theme_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getIsLogin();
    super.initState();
  }

  Future<void> getIsLogin() async {
    final userData = await UserService().getUserData();
    if (userData['token'] != null && userData['token'] != '') {
      // User is logged in
      Timer(
        const Duration(seconds: 4),
        () => Navigator.popAndPushNamed(context, '/home'),
      );
    } else {
      // User is not logged in
      Timer(
        const Duration(seconds: 4),
        () => Navigator.popAndPushNamed(context, '/login'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    const Color(0xFF141414),
                    const Color(0xFF1A1A1A),
                    const Color(0xFF171717),
                  ]
                : [
                    const Color(0xFFF0F0F0),
                    const Color(0xFFF7F7F7),
                    const Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Brand Icon with Animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:
                              Theme.of(context).brightness == Brightness.dark
                                  ? [
                                      const Color(0xFF8B5CF6), // Purple
                                      const Color(0xFFEC4899), // Pink
                                      const Color(0xFF06B6D4), // Cyan
                                    ]
                                  : [
                                      const Color(0xFF262626), // Dark gray
                                      const Color(0xFF404040), // Medium gray
                                      const Color(0xFF525252), // Light gray
                                    ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF8B5CF6).withOpacity(0.3)
                                    : const Color(0xFF262626).withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ThemedIcon(
                        ThemeIcons.brand,
                        size: 60,
                        color: Colors.white,
                        useThemeColor: false,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // App Name with Animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 2000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: CustomText(
                      'Blog App',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Subtitle with Animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 2500),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: CustomText(
                      'Your Creative Space',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Loading Indicator with Animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 3000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
