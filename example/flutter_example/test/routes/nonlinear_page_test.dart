import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';
import 'nonlinear_page/nonlinear_mock.dart';

void main() {
  group("Testing the 'NonlinearPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: NonlinearPage(),
        ),
      );

      expect(find.byType(NonlinearBody), findsOneWidget);
      expect(find.byType(NonlinearPage), findsOneWidget);
    });

    testWidgets('Making sure that pages can be changed', (tester) async {
      var bracketing = '';
      var singlePoint = '';

      await tester.pumpWidget(
        MockWrapper(
          child: Builder(
            builder: (context) {
              bracketing = context.l10n.bracketing;
              singlePoint = context.l10n.single_point;

              return const NonlinearPage();
            },
          ),
        ),
      );

      // Bracketing page
      await tester.tap(find.text(bracketing));
      await tester.pumpAndSettle();
      expect(find.text(bracketing), findsNWidgets(2));
      expect(find.text(singlePoint), findsOneWidget);

      // Single point page
      await tester.tap(find.text(singlePoint));
      await tester.pumpAndSettle();
      expect(find.text(singlePoint), findsNWidgets(2));
      expect(find.text(bracketing), findsOneWidget);
    });
  });

  group('Golden tests - NonlinearBody', () {
    Future<void> solveNonlinear(
      WidgetTester tester, {
      bool withError = false,
    }) async {
      final equationInput = find.byKey(const Key('EquationInput-function'));
      final paramInput = find.byKey(const Key('EquationInput-first-param'));
      final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

      // Filling the forms
      await tester.enterText(equationInput, 'x-3');

      if (withError) {
        await tester.enterText(paramInput, '0');
      } else {
        await tester.enterText(paramInput, '3');
      }

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(NonlinearResults).last);
      await tester.pumpAndSettle();
    }

    testWidgets('NonlinearBody - small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1400));

      await tester.pumpWidget(
        MockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/nonlinear_body_small_screen.png'),
      );
    });

    testWidgets('NonlinearBody - large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));

      await tester.pumpWidget(
        MockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/nonlinear_body_large_screen.png'),
      );
    });

    testWidgets('NonlinearBody - small screen with data', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1500));

      await tester.pumpWidget(
        MockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      await solveNonlinear(tester);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/nonlinear_body_small_screen_with_data.png'),
      );
    });

    testWidgets('NonlinearBody - large screen with data', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 1100));

      await tester.pumpWidget(
        MockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      await solveNonlinear(tester);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/nonlinear_body_large_screen_with_data.png'),
      );
    });

    testWidgets('NonlinearBody - small screen with error', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1500));

      await tester.pumpWidget(
        MockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      await solveNonlinear(tester, withError: true);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/nonlinear_body_small_screen_with_error.png'),
      );
    });

    testWidgets('NonlinearBody - large screen with error', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 1100));

      await tester.pumpWidget(
        MockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      await solveNonlinear(tester, withError: true);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/nonlinear_body_large_screen_with_error.png'),
      );
    });
  });
}
