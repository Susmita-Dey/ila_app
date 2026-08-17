import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ila_logo.dart';
import '../../../main.dart';
import '../../onboarding/presentation/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Guard flag — prevents double-navigation if widget rebuilds unexpectedly.
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Remove the native splash as soon as our branded Flutter UI is live —
    // this is the "seamless handoff" that eliminates the white-flash bug.
    FlutterNativeSplash.remove();

    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Hold the branded splash for exactly 2 seconds for brand impression.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool('has_onboarded') ?? false;

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            hasOnboarded ? const MainNavigation() : const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Ila geometric logo ────────────────────────────────────────
            const IlaLogo(size: 72)
                .animate()
                .scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1.0, 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: const Duration(milliseconds: 400)),

            const SizedBox(height: 20),

            // ── "Ila" wordmark in elegant italic serif ─────────────────────
            Text(
              'Ila Health',
              style: GoogleFonts.fleurDeLeah(
                fontSize: 56, // Fleur De Leah is quite delicate, so bumping the size up slightly helps legibility
                fontWeight: FontWeight.w600,
                color: AppColors.charcoalInk,
                height: 1.0,
              ),
            )
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}
