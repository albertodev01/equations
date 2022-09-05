import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';
import 'polynomial_page/polynomial_mock.dart';

void main() {
  group("Testing the 'PolynomialPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: PolynomialPage(),
        ),
      );

      expect(find.byType(PolynomialBody), findsOneWidget);
      expect(find.byType(PolynomialPage), findsOneWidget);
    });

    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: PolynomialPage(),
        ),
      );

      expect(find.byType(PolynomialBody), findsOneWidget);
      expect(find.byType(PolynomialPage), findsOneWidget);
    });

    testWidgets('Making sure that pages can be changed', (tester) async {
      var firstDegree = '';
      var secondDegree = '';
      var thirdDegree = '';
      var fourthDegree = '';

      // There will always be 1 string matching the name because of the bottom
      // navigation bar. To make sure we're on a certain page, we need to check
      // whether 2 text are present (one on the bottom bar AND one at the top
      // of the newly opened page).
      await tester.pumpWidget(
        MockWrapper(
          child: Builder(
            builder: (context) {
              firstDegree = context.l10n.firstDegree;
              secondDegree = context.l10n.secondDegree;
              thirdDegree = context.l10n.thirdDegree;
              fourthDegree = context.l10n.fourthDegree;

              return const PolynomialPage();
            },
          ),
        ),
      );

      // Second degree page
      await tester.tap(find.text(secondDegree));
      await tester.pumpAndSettle();
      expect(find.text(firstDegree), findsOneWidget);
      expect(find.text(secondDegree), findsNWidgets(2));
      expect(find.text(thirdDegree), findsOneWidget);
      expect(find.text(fourthDegree), findsOneWidget);

      // Third degree page
      await tester.tap(find.text(thirdDegree));
      await tester.pumpAndSettle();
      expect(find.text(firstDegree), findsOneWidget);
      expect(find.text(secondDegree), findsOneWidget);
      expect(find.text(thirdDegree), findsNWidgets(2));
      expect(find.text(fourthDegree), findsOneWidget);

      // Fourth degree page
      await tester.tap(find.text(fourthDegree));
      await tester.pumpAndSettle();
      expect(find.text(firstDegree), findsOneWidget);
      expect(find.text(secondDegree), findsOneWidget);
      expect(find.text(thirdDegree), findsOneWidget);
      expect(find.text(fourthDegree), findsNWidgets(2));

      // Fist degree page
      await tester.tap(find.text(firstDegree));
      await tester.pumpAndSettle();
      expect(find.text(firstDegree), findsNWidgets(2));
      expect(find.text(secondDegree), findsOneWidget);
      expect(find.text(thirdDegree), findsOneWidget);
      expect(find.text(fourthDegree), findsOneWidget);
    });
  });

  group('Golden tests - NonlinearBody', () {
    Future<void> solvePolynomial(WidgetTester tester) async {
      final firstInput = find.byKey(
        const Key('PolynomialInputField-coefficient-0'),
      );
      final secondInput = find.byKey(
        const Key('PolynomialInputField-coefficient-1'),
      );
      final solveButton = find.byKey(const Key('Polynomial-button-solve'));

      // Filling the form
      await tester.enterText(firstInput, '1');
      await tester.enterText(secondInput, '2');

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(ComplexResultCard).last);
      await tester.pumpAndSettle();
    }

    testWidgets('PolynomialBody - small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1400));

      await tester.pumpWidget(
        MockPolynomialWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/polynomial_body_small_screen.png'),
      );
    });

    testWidgets('PolynomialBody - large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));

      await tester.pumpWidget(
        MockPolynomialWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/polynomial_body_large_screen.png'),
      );
    });

    testWidgets('PolynomialBody - small screen with data', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1500));

      await tester.pumpWidget(
        MockPolynomialWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      await solvePolynomial(tester);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/polynomial_body_small_screen_with_data.png'),
      );
    });

    testWidgets('PolynomialBody - large screen with data', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 1100));

      await tester.pumpWidget(
        MockPolynomialWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      await solvePolynomial(tester);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/polynomial_body_large_screen_with_data.png'),
      );
    });
  });
}
