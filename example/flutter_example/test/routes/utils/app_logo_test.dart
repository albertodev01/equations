import 'package:equations_solver/routes/utils/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'AppLogo' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(child: AppLogo()));

      expect(find.byType(AppLogo), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testGoldens('AppLogo', (tester) async {
      const widget = SizedBox(
        width: 300,
        height: 150,
        child: Scaffold(body: AppLogo()),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 300),
      );
      await screenMatchesGolden(tester, 'app_logo');
    });
  });
}
