import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Making sure that localization works on context', (tester) async {
    late final AppLocalizations? localizations;

    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          localizations = AppLocalizations.of(context);

          return const SizedBox();
        },
      ),
    ));

    expect(localizations, isNotNull);
  });
}
