import 'package:equations_solver/routes/utils/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../mock_wrapper.dart';

void main() {
  group('Making sure that sections logos can be rendered', () {
    testWidgets("Testing 'AppLogo'", (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: AppLogo(),
      ));

      expect(find.byType(AppLogo), findsOneWidget);
    });

    testGoldens('AppLogo', (tester) async {
      final builder = GoldenBuilder.column()..addScenario('', const AppLogo());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: Scaffold(body: child)),
        surfaceSize: const Size(350, 350),
      );
      await screenMatchesGolden(tester, 'app_logo');
    });
  });
}
