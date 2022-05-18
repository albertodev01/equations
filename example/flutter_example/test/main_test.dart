import 'package:equations_solver/main.dart' as app_main;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing the entry point of the app', () {
    testWidgets(
      "Making sure that 'main()' doesn't throw",
      (tester) async {
        var throws = false;

        try {
          app_main.main();
        } on Exception {
          throws = true;
        }

        expect(throws, isFalse);
      },
    );

    testWidgets(
      "Making sure that the root widget contains a 'MaterialApp' and"
      ' it is correctly initialized',
      (tester) async {
        await tester.pumpWidget(const app_main.EquationsApp());
        expect(find.byType(MaterialApp), findsOneWidget);

        // Checking MaterialApp's properties
        final materialApp = tester.firstWidget<MaterialApp>(
          find.byType(MaterialApp),
        );

        expect(materialApp.supportedLocales.length, equals(3));
        expect(materialApp.routerDelegate, isNotNull);
        expect(materialApp.routeInformationParser, isNotNull);
        expect(materialApp.debugShowCheckedModeBanner, isFalse);
      },
    );
  });
}
