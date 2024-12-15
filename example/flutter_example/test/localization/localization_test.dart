import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localization', () {
    testWidgets('Smoke test', (tester) async {
      late final AppLocalizations? localizations;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              localizations = context.l10n;

              return const SizedBox();
            },
          ),
        ),
      );

      expect(localizations, isNotNull);
    });
  });
}
