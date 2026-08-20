import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imyra_app/main.dart';
import 'package:imyra_app/core/widgets/imyra_logo.dart';
import 'package:imyra_app/core/providers/database_provider.dart';
import 'package:imyra_app/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:imyra_app/core/providers/preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App obscures UI when inactive or paused to prevent screenshots', (tester) async {
    // Mock the local_auth channel to prevent hanging during the test
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/local_auth'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getAvailableBiometrics') {
          return <String>[];
        }
        return true;
      },
    );

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({'app_lock_enabled': true, 'has_onboarded': true});
    final prefs = await SharedPreferences.getInstance();

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ImyraApp(),
      ),
    );
    
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(seconds: 1));
    
    expect(find.descendant(of: find.byType(Stack), matching: find.byType(ImyraLogo)).last, findsOneWidget);
    
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(seconds: 1));
    
    // Pump enough time to flush out SplashScreen and authentication Future.delayed timers
    // Otherwise the fakeAsync zone hangs forever waiting for them to complete.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    
    // Dispose container and flush streams
    container.dispose();
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    
    await db.close();
  });
}
