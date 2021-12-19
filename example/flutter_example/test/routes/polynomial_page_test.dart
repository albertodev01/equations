import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'PolynomialPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: PolynomialPage(),
      ));

      expect(find.byType(PolynomialBody), findsOneWidget);
      expect(find.byType(PolynomialPage), findsOneWidget);
    });

    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: PolynomialPage(),
      ));

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
      await tester.pumpWidget(MockWrapper(
        child: Builder(builder: (context) {
          firstDegree = context.l10n.firstDegree;
          secondDegree = context.l10n.secondDegree;
          thirdDegree = context.l10n.thirdDegree;
          fourthDegree = context.l10n.fourthDegree;

          return const PolynomialPage();
        }),
      ));

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
}
