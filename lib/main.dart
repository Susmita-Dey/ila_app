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
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
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

  bool hasOnboarded = false;

  try {
    debugPrint('[INIT] Starting Initialization Sequence...');
    
    debugPrint('[INIT] Initializing Notifications...');
    await NotificationService.init();
    debugPrint('[INIT] Notifications Initialized successfully.');

    debugPrint('[INIT] Fetching SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    hasOnboarded = prefs.getBool('has_onboarded') ?? false;
    debugPrint('[INIT] SharedPreferences fetched successfully.');

    ErrorLogger.info('App Initialized');
  } catch (e, stack) {
    debugPrint('[INIT ERROR] Initialization failed: $e');
    ErrorLogger.error('Initialization Error', e, stack);
  } finally {
    debugPrint('[INIT] Removing FlutterNativeSplash...');
    FlutterNativeSplash.remove();
  }

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
  bool _obscureUI = false; // Default to false until we know app lock is enabled
  bool _isAuthenticating = false;
  bool _isAuthenticated = false;
  DateTime? _backgroundedTime;
  bool _appLockEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAppLockSetting();
  }

  Future<void> _loadAppLockSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final isLocked = prefs.getBool('app_lock_enabled') ?? false;
    setState(() {
      _appLockEnabled = isLocked;
    });

    if (isLocked && widget.hasOnboarded) {
      setState(() => _obscureUI = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _authenticate();
      });
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating || !_appLockEnabled || !widget.hasOnboarded) return;
    
    setState(() {
      _isAuthenticating = true;
      _obscureUI = true;
    });

    final success = await AuthService.authenticate();
    
    if (mounted) {
      setState(() {
        _isAuthenticated = success;
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
    if (!_appLockEnabled || !widget.hasOnboarded) return;

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      if (!_isAuthenticating) {
        _backgroundedTime = DateTime.now();
        setState(() {
          _obscureUI = true;
          _isAuthenticated = false;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_isAuthenticating) return;

      if (_backgroundedTime != null) {
        final diff = DateTime.now().difference(_backgroundedTime!);
        // Only lock if backgrounded for more than 10 seconds
        if (diff.inSeconds > 10) {
          _authenticate();
        } else {
          setState(() {
            _obscureUI = false;
            _isAuthenticated = true;
          });
        }
      } else {
        _authenticate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ila',
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.tabToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label: AppLocalizations.of(context)!.tabInsights,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settingsTitle,
          ),
        ],
      ),
    );
  }
}

