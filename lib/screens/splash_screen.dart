import 'dart:async';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

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
                    const Color(0xFF0F0F0F), // Darkest background
                    const Color(0xFF1A1A1A), // Dark surface
                  ]
                : [
                    const Color(0xFFFAFAFA), // Light background
                    const Color(0xFFFFFFFF), // White surface
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4)
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shopping cart base
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                    // Shopping bag alternative for dark mode
                    if (Theme.of(context).brightness == Brightness.dark)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'i',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // App Name
              Text(
                'iCart',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Shopping Paradise',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 48),

              // Loading Indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
