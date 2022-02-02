import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Integration tests on the Nonlinear page', () {
    testWidgets(
      'Testing nonlinear equations - Newton',
          (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the polynomial page
        await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
        await tester.pumpAndSettle();

        // Inserting data
        final finder = find.byType(TextFormField);
        await tester.enterText(finder.first, 'x-2.25');
        await tester.enterText(finder.last, '2');

        // Solving
        await tester.tap(find.byKey(const Key('Nonlinear-button-solve')));
        await tester.pumpAndSettle();

        // Expecting solutions
        expect(find.byType(RealResultCard), findsNWidgets(3));

        // Cleaning
        await tester.tap(find.byKey(const Key('Nonlinear-button-clean')));
        await tester.pump();
        expect(find.byType(RealResultCard), findsNothing);
      },
    );
  });
}
