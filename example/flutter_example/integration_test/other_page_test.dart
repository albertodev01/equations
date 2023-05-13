import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  var needsOpenPage = true;

  Future<void> testMatrix(WidgetTester tester) async {
    if (needsOpenPage) {
      // Opening the system page
      await tester.tap(find.byKey(const Key('OtherLogo-Container')));
      await tester.pumpAndSettle();

      needsOpenPage = false;
    }

    await tester.enterText(
      find.byType(TextFormField),
      '1',
    );

    // Evaluating
    final solveBtn = find.byKey(const Key('MatrixAnalyze-button-analyze'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pumpAndSettle();

    // Cleaning
    final cleanBtn = find.byKey(const Key('MatrixAnalyze-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
  }

  Future<void> testComplex(WidgetTester tester) async {
    // Moving to the 'Bracketing' page
    tester
        .widget<InheritedNavigation>(find.byType(InheritedNavigation))
        .navigationIndex
        .value = 1;

    await tester.pumpAndSettle();

    // Entering values
    await tester.enterText(
      find.byKey(const Key('ComplexNumberInput-TextFormField-RealPart')),
      '-2',
    );
    await tester.enterText(
      find.byKey(const Key('ComplexNumberInput-TextFormField-ImaginaryPart')),
      '1',
    );

    // Solving
    final solveBtn = find.byKey(const Key('ComplexAnalyze-button-analyze'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pumpAndSettle();

    // Result cards
    await tester.ensureVisible(find.byType(RealResultCard).last);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsWidgets);

    await tester.ensureVisible(find.byType(ComplexResultCard).last);
    await tester.pumpAndSettle();

    expect(find.byType(ComplexResultCard), findsWidgets);

    // Cleaning
    final cleanBtn = find.byKey(const Key('ComplexAnalyze-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
    expect(find.byType(ComplexResultCard), findsNothing);
  }

  group('Integration tests on the Other page', () {
    testWidgets(
      'Testing matrix analysis',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testMatrix(tester);
      },
    );

    testWidgets(
      'Testing complex numbers analysis',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testComplex(tester);
      },
    );
  });
}
