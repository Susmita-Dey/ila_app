import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mira_app/main.dart';
import 'package:mira_app/core/widgets/ila_logo.dart';
import 'package:mira_app/core/theme/app_theme.dart';
import 'package:mira_app/core/providers/database_provider.dart';
import 'package:mira_app/core/database/app_database.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('App obscures UI when inactive or paused to prevent screenshots', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const IlaApp(),
      ),
    );
    
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(seconds: 1));
    
    expect(find.descendant(of: find.byType(Stack), matching: find.byType(IlaLogo)).last, findsOneWidget);
    
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(seconds: 1));
    
    // Dispose container and flush streams
    container.dispose();
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    
    await db.close();
  });
}
