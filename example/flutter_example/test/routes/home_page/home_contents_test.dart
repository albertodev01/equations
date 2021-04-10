import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:equations_solver/routes/home_page/home_contents.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'HomeContents' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(child: HomeContents()));

      expect(find.byType(CardContainer), findsNWidgets(2));
      expect(find.byType(PolynomialLogo), findsOneWidget);
      expect(find.byType(NonlinearLogo), findsOneWidget);
    });

    testWidgets(
        'Making sure that tapping on the CardContainer widget for '
        'polynomial equations opens a new route', (tester) async {
      await tester.pumpWidget(const MockWrapper(child: HomeContents()));
      final finder = find.byKey(const Key('PolynomialLogo-Container'));

      // Tapping an waiting for the animations to complete
      await tester.tap(finder);
      await tester.pumpAndSettle();

      // Expecting to be on the new page
      expect(find.byType(PolynomialPage), findsOneWidget);
    });

    testWidgets(
        'Making sure that tapping on the CardContainer widget for '
        'polynomial equations opens a new route', (tester) async {
      await tester.pumpWidget(const MockWrapper(child: HomeContents()));
      final finder = find.byKey(const Key('NonlinearLogo-Container'));

      // Tapping an waiting for the animations to complete
      await tester.tap(finder);
      await tester.pumpAndSettle();

      // Expecting to be on the new page
      expect(find.byType(NonlinearPage), findsOneWidget);
    });

    testGoldens('HomeContents', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const HomeContents());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(800, 800),
      );
      await screenMatchesGolden(tester, 'home_contents');
    });
  });
}
