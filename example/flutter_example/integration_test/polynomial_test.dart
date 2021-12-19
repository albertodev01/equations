import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> testPage({
    required WidgetTester tester,
    required List<String> inputs,
  }) async {
    // Entering data
    final input = find.byType(TextFormField);

    for (var i = 0; i < inputs.length; ++i) {
      await tester.enterText(input.at(i), inputs[i]);
    }
    await tester.pumpAndSettle();

    await tester.enterText(input.at(1), '-e/2');
    await tester.pumpAndSettle();

    // Solving
    await tester.tap(find.byKey(const Key('Polynomial-button-solve')));
    await tester.pumpAndSettle();

    expect(find.byType(ComplexResultCard), findsNWidgets(inputs.length));
    expect(find.byType(Slider), findsOneWidget);

    // Clearing
    await tester.tap(find.byKey(const Key('Polynomial-button-clean')));
    await tester.pumpAndSettle();

    expect(find.byType(ComplexResultCard), findsNothing);
    expect(find.byType(Slider), findsNothing);
  }

  group('Integration tests on the polynomial solver page', () {
    testWidgets('Making sure that linear equations can be solved',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Opening the 'Polynomial' solver
      await tester.tap(find.byType(PolynomialLogo));
      await tester.pumpAndSettle();

      // Testing
      await testPage(
        inputs: ['2', '4/5'],
        tester: tester,
      );
    });

    testWidgets('Making sure that quadratic equations can be solved',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Opening the 'Polynomial' solver and going to 'Quadratic'
      await tester.tap(find.byType(PolynomialLogo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Quadratic'));
      await tester.pumpAndSettle();

      // Testing
      await testPage(
        inputs: ['2', 'e', '1/2'],
        tester: tester,
      );
    });

    testWidgets('Making sure that cubic equations can be solved',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Opening the 'Polynomial' solver and going to 'Cubic'
      await tester.tap(find.byType(PolynomialLogo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cubic'));
      await tester.pumpAndSettle();

      // Testing
      await testPage(
        inputs: ['2', 'e', '1/2', '-3'],
        tester: tester,
      );
    });

    testWidgets('Making sure that quartic equations can be solved',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Opening the 'Polynomial' solver and going to 'Quartic'
      await tester.tap(find.byType(PolynomialLogo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Quartic'));
      await tester.pumpAndSettle();

      // Testing
      await testPage(
        inputs: ['2', 'e', '1/2', '-3', '0'],
        tester: tester,
      );
    });
  });
}
