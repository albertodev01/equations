import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
        const MockWrapperWithNavigator(),
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
  });

  group('Golden tests - EquationTextFormatter', () {
    testWidgets('GoBackButton', (tester) async {
      await tester.binding.setSurfaceSize(const Size(100, 100));

      await tester.pumpWidget(
        const MockWrapper(
          child: SizedBox(
            width: 90,
            height: 90,
            child: GoBackButton(),
          ),
        ),
      );
      await expectLater(
        find.byType(GoBackButton),
        matchesGoldenFile('goldens/go_back_button.png'),
      );
    });

    testWidgets('GoBackButton', (tester) async {
      await tester.binding.setSurfaceSize(const Size(100, 100));

      await tester.pumpWidget(
        const MockWrapper(
          child: SizedBox(
            width: 90,
            height: 90,
            child: GoBackButton(),
          ),
        ),
      );

      await tester.press(find.byType(GoBackButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GoBackButton),
        matchesGoldenFile('goldens/go_back_button_pressed.png'),
      );
    });
  });
}
