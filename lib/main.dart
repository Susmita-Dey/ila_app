import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/today/presentation/today_screen.dart';
import 'features/report/presentation/report_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'core/notifications/notification_service.dart';
import 'core/diagnostics/error_logger.dart';
import 'dart:ui';
import 'core/widgets/imyra_logo.dart';
import 'core/services/auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'l10n/app_localizations.dart';
import 'core/providers/preferences_provider.dart';

void main() async {
  // Preserve the native splash until SplashScreen.initState() explicitly removes it,
  // preventing the white-flash gap between the OS splash and Flutter rendering.
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

  try {
    debugPrint('[INIT] Starting Initialization Sequence...');

    debugPrint('[INIT] Initializing Notifications...');
    await NotificationService.init();
    debugPrint('[INIT] Notifications Initialized successfully.');

    ErrorLogger.info('App Initialized');
  } catch (e, stack) {
    debugPrint('[INIT ERROR] Initialization failed: $e');
    ErrorLogger.error('Initialization Error', e, stack);
  }
  // NOTE: FlutterNativeSplash.remove() is intentionally NOT called here.
  // It is called inside SplashScreen.initState() so the handoff is seamless.

  // Load SharedPreferences synchronously before app starts
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ImyraApp(),
    ),
  );
}

class ImyraApp extends StatefulWidget {
  const ImyraApp({super.key});

  @override
  State<ImyraApp> createState() => _ImyraAppState();
}

class _ImyraAppState extends State<ImyraApp> with WidgetsBindingObserver {
  bool _obscureUI = false; // Default to false until we know app lock is enabled
  bool _isAuthenticating = false;

  DateTime? _backgroundedTime;
  bool _appLockEnabled = false;
  // Tracks whether onboarding is done so we don't trigger biometrics mid-flow.
  bool _hasOnboarded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAppLockSetting();
  }

  Future<void> _loadAppLockSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final isLocked = prefs.getBool('app_lock_enabled') ?? false;
    final hasOnboarded = prefs.getBool('has_onboarded') ?? false;
    if (!mounted) return;
    setState(() {
      _appLockEnabled = isLocked;
      _hasOnboarded = hasOnboarded;
    });

    // Only prompt biometrics if onboarding is complete; never lock mid-onboarding.
    if (isLocked && hasOnboarded) {
      setState(() => _obscureUI = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _authenticate();
      });
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating || !_appLockEnabled || !_hasOnboarded) return;

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
    if (!_appLockEnabled || !_hasOnboarded) return;

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      if (!_isAuthenticating) {
        _backgroundedTime = DateTime.now();
        setState(() {
          _obscureUI = true;
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
      title: 'Imyra',
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // SplashScreen is always the entry point; it reads SharedPreferences
      // and routes to OnboardingScreen or MainNavigation after the 2-second hold.
      home: const SplashScreen(),
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
                        const ImyraLogo(size: 80),
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
  
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      TodayScreen(onNavigateToSettings: () => setState(() => _currentIndex = 2)),
      const ReportScreen(),
      const SettingsScreen(),
    ];
  }

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

