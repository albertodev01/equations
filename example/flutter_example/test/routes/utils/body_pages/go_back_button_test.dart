import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'GoBackButton' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Scaffold(
            body: GoBackButton(),
          ),
        ),
      );

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('Making sure that the button can be tapped', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Scaffold(
            body: HomePage(),
          ),
        ),
      );

      // Opening a page
      await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
      await tester.pumpAndSettle();
      expect(find.byType(PolynomialPage), findsOneWidget);

      // Going back
      await tester.tap(find.byType(GoBackButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testGoldens('GoBackButton', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          '',
          const SizedBox(
            width: 90,
            height: 90,
            child: Scaffold(
              body: GoBackButton(),
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(150, 150),
      );
      await screenMatchesGolden(tester, 'go_back_button');
    });
  });
}
