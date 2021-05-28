import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:flutter/material.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'NonlinearPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: NonlinearPage(),
      ));

      expect(find.byType(NonlinearBody), findsOneWidget);
      expect(find.byType(NonlinearPage), findsOneWidget);
    });

    testWidgets('Making sure that pages can be changed', (tester) async {
      var title = '';
      var wrongTitle = '';

      await tester.pumpWidget(MockWrapper(
        child: Builder(builder: (context) {
          title = context.l10n.bracketing;
          wrongTitle = context.l10n.single_point;

          return const NonlinearPage();
        }),
      ));

      final bottomRight = tester.getBottomRight(find.byType(NonlinearPage));

      await tester.tapAt(bottomRight);
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(wrongTitle), findsWidgets);
    });
  });
}
