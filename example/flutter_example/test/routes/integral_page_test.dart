import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'integral_page/integral_mock.dart';
import 'mock_wrapper.dart';

void main() {
  group("Testing the 'IntegralPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: IntegralPage(),
        ),
      );

      expect(find.byType(IntegralPage), findsOneWidget);
      expect(find.byType(EquationScaffold), findsOneWidget);
      expect(find.byType(IntegralBody), findsOneWidget);
    });
  });

  group('Golden tests - IntegralBody', () {
    Future<void> solveIntegral(WidgetTester tester) async {
      final equationInput = find.byKey(const Key('EquationInput-function'));
      final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
      final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

      // Filling the forms
      await tester.enterText(equationInput, 'x+2');
      await tester.enterText(lowerInput, '1');
      await tester.enterText(upperInput, '3');

      // Solving the equation
      await tester.tap(find.byKey(const Key('Integral-button-solve')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(IntegralResultsWidget).last);
      await tester.pumpAndSettle();
    }

    testWidgets('IntegralBody - small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1300));

      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.simpson.name,
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/integral_body_small_screen.png'),
      );
    });

    testWidgets('IntegralBody - large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));

      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.simpson.name,
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/integral_body_large_screen.png'),
      );
    });

    testWidgets('IntegralBody - small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1300));

      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.simpson.name,
        ),
      );

      await solveIntegral(tester);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/integral_body_small_screen_with_data.png'),
      );
    });

    testWidgets('IntegralBody - large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 900));

      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.simpson.name,
        ),
      );

      await solveIntegral(tester);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/integral_body_large_screen_with_data.png'),
      );
    });
  });
}
