import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'SystemPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: SystemPage(),
      ));

      expect(find.byType(SystemBody), findsOneWidget);
      expect(find.byType(SystemPage), findsOneWidget);
    });

    testWidgets('Making sure that pages can be changed', (tester) async {
      var rowReduction = '';
      var factorization = '';
      var iterative = '';

      // There will always be 1 string matching the name because of the bottom
      // navigation bar. To make sure we're on a certain page, we need to check
      // whether 2 text are present (one on the bottom bar AND one at the top
      // of the newly opened page).
      await tester.pumpWidget(MockWrapper(
        child: Builder(builder: (context) {
          rowReduction = context.l10n.row_reduction;
          factorization = context.l10n.factorization;
          iterative = context.l10n.iterative;

          return const SystemPage();
        }),
      ));

      // Iterative page
      await tester.tap(find.text(iterative));
      await tester.pumpAndSettle();
      expect(find.text(rowReduction), findsOneWidget);
      expect(find.text(factorization), findsOneWidget);
      expect(find.text(iterative), findsNWidgets(2));

      // Row reduction page
      await tester.tap(find.text(rowReduction));
      await tester.pumpAndSettle();
      expect(find.text(rowReduction), findsNWidgets(2));
      expect(find.text(factorization), findsOneWidget);
      expect(find.text(iterative), findsOneWidget);

      // Factorization page
      await tester.tap(find.text(factorization));
      await tester.pumpAndSettle();
      expect(find.text(rowReduction), findsOneWidget);
      expect(find.text(factorization), findsNWidgets(2));
      expect(find.text(iterative), findsOneWidget);
    });
  });
}
