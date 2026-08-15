import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/today/presentation/today_screen.dart';
import 'features/report/presentation/report_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'core/notifications/notification_service.dart';
import 'core/diagnostics/error_logger.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Flutter Framework Errors (Render/Widget build errors)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    ErrorLogger.error(
      'FlutterError: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );
  };

  // 2. Platform / Asynchronous Errors
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorLogger.error('PlatformDispatcher Error: $error', error, stack);
    return true;
  };

  // Initialize notifications
  await NotificationService.init();

  ErrorLogger.info('App Initialized');

  runApp(
    const ProviderScope(
      child: IlaApp(),
    ),
  );
}

class IlaApp extends StatelessWidget {
  const IlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ila',
      theme: AppTheme.light,
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const TodayScreen(),
    const ReportScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.warmIvory,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.softLavender.withValues(alpha: 0.3),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

