import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

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
}
