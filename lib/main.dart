import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'l10n/app_localizations.dart';
import 'core/providers/preferences_provider.dart';
import 'core/providers/database_provider.dart';

void main() async {
  // We are removing FlutterNativeSplash.preserve() to fix the deadlock with biometric prompt.
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

final splashScreenDoneProvider = StateProvider<bool>((ref) => false);

class ImyraApp extends ConsumerStatefulWidget {
  const ImyraApp({super.key});

  @override
  ConsumerState<ImyraApp> createState() => _ImyraAppState();
}

class _ImyraAppState extends ConsumerState<ImyraApp> with WidgetsBindingObserver {
  bool _obscureUI = false; // Default to false until we know app lock is enabled
  bool _isAuthenticating = false;

  DateTime? _backgroundedTime;

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

    // Only prompt biometrics if onboarding is complete; never lock mid-onboarding.
    if (isLocked && hasOnboarded) {
      setState(() => _obscureUI = true);
      // We don't call _authenticate() immediately here.
      // We wait for the splash screen to finish via splashScreenDoneProvider.
    }
  }

  Future<void> _authenticate() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final appLockEnabled = prefs.getBool('app_lock_enabled') ?? false;
    final hasOnboarded = prefs.getBool('has_onboarded') ?? false;

    if (_isAuthenticating || !appLockEnabled || !hasOnboarded) return;

    setState(() {
      _isAuthenticating = true;
      _obscureUI = true;
    });

    final success = await AuthService.authenticate();

    if (mounted) {
      setState(() {
        _obscureUI = !success;
      });
      
      // Delay resetting the authenticating flag by 500ms.
      // This absorbs any rogue AppLifecycleState.inactive events that the OS 
      // might fire while dismissing the native biometric prompt window, 
      // preventing the app from instantly locking itself again.
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isAuthenticating = false;
          });
        }
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
    final prefs = ref.read(sharedPreferencesProvider);
    final appLockEnabled = prefs.getBool('app_lock_enabled') ?? false;
    final hasOnboarded = prefs.getBool('has_onboarded') ?? false;

    if (!appLockEnabled || !hasOnboarded) return;

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      if (!_isAuthenticating) {
        _backgroundedTime = DateTime.now();
        setState(() {
          _obscureUI = true;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      // Rehydrate routine notifications (moving window)
      ref.read(routineDaoProvider).getActiveRoutines().then((routines) {
        NotificationService.rehydrateRoutineNotifications(routines);
      });

      if (_isAuthenticating) return;

      if (_backgroundedTime != null) {
        final diff = DateTime.now().difference(_backgroundedTime!);
        _backgroundedTime = null; // Clear it so we don't trigger again when the prompt closes
        
        // Only lock if backgrounded for more than 10 seconds
        if (diff.inSeconds > 10) {
          _authenticate();
        } else {
          setState(() {
            _obscureUI = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashScreenDoneProvider, (previous, current) {
      final prefs = ref.read(sharedPreferencesProvider);
      final appLockEnabled = prefs.getBool('app_lock_enabled') ?? false;
      final hasOnboarded = prefs.getBool('has_onboarded') ?? false;
      
      if (current == true && appLockEnabled && hasOnboarded) {
        // Wait for the pushReplacement animation (500ms) to finish before showing prompt.
        // Android cancels BiometricPrompt if launched during a window transition!
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _authenticate();
        });
      }
    });

    final isSplashDone = ref.watch(splashScreenDoneProvider);
    final shouldObscure = _obscureUI && isSplashDone;

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
            if (shouldObscure)
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

