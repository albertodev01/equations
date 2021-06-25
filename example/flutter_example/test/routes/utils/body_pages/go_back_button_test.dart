import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'GoBackButton' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: Scaffold(
          body: GoBackButton(),
        ),
      ));

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
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
            ));

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(150, 150),
      );
      await screenMatchesGolden(tester, 'go_back_button');
    });
  });
}
