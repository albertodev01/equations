import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Integration tests on the Home page', () {
    testWidgets(
      'Testing route transition animations',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the polynomial page and coming back
        await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        // Opening the nonlinear page and coming back
        await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        // Opening the system page and coming back
        await tester.tap(find.byKey(const Key('SystemsLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        // Opening the integral page and coming back
        await tester.tap(find.byKey(const Key('IntegralsLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        // Opening the other page and coming back
        await tester.tap(find.byKey(const Key('OtherLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();
      },
    );
  });
}
