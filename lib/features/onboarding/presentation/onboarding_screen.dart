import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_onboarded', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildPage(
                    title: 'Your health.\nYour space.',
                    description: 'Ila stores all your records securely on this device. Zero cloud sync. Zero ads. Just you and your data.',
                    icon: Icons.shield_outlined,
                  ),
                  _buildPage(
                    title: 'Track With\nPrecision.',
                    description: 'Log your symptoms, flow, and treatments effortlessly. Built for complex cycles and PCOS.',
                    icon: Icons.water_drop_outlined,
                  ),
                  _buildPage(
                    title: 'Secured by\nBiometrics.',
                    description: 'Your clinical data is protected by FaceID and unbreakable AES-256 encrypted backups.',
                    icon: Icons.fingerprint,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.brandAction : AppColors.lightBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(duration: 400.ms, curve: Curves.easeOutCubic);
                      } else {
                        _completeOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandAction,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Get Started' : 'Next',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String description, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.brandLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, size: 64, color: AppColors.brandAction),
          ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 48),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.deepInk,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
          const SizedBox(height: 24),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.mutedSage,
              fontSize: 18,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
