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
import 'core/widgets/ila_logo.dart';
import 'core/services/auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

  final prefs = await SharedPreferences.getInstance();
  final bool hasOnboarded = prefs.getBool('has_onboarded') ?? false;

  runApp(
    ProviderScope(
      child: IlaApp(hasOnboarded: hasOnboarded),
    ),
  );
}

class IlaApp extends StatefulWidget {
  final bool hasOnboarded;
  const IlaApp({super.key, required this.hasOnboarded});

  @override
  State<IlaApp> createState() => _IlaAppState();
}

class _IlaAppState extends State<IlaApp> with WidgetsBindingObserver {
  bool _obscureUI = true;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    
    setState(() {
      _isAuthenticating = true;
      _obscureUI = true;
    });

    final success = await AuthService.authenticate();
    
    if (mounted) {
      setState(() {
        _obscureUI = !success;
        _isAuthenticating = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      setState(() {
        _obscureUI = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      _authenticate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ila',
      theme: AppTheme.light,
      home: widget.hasOnboarded ? const MainNavigation() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            if (_obscureUI)
              GestureDetector(
                onTap: () {
                  if (!_isAuthenticating) {
                    _authenticate();
                  }
                },
                child: Container(
                  color: AppColors.warmIvory,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const IlaLogo(size: 80),
                        if (!_isAuthenticating) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Tap to unlock',
                            style: TextStyle(
                              color: AppColors.charcoalInk,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
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

