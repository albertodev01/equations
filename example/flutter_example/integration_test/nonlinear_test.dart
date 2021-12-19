import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration tests on the nonlinear solver page', () {
    testWidgets(
      'Making sure that single point equations can be solved',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the 'Nonlinear' solver
        await tester.tap(find.byType(NonlinearLogo));
        await tester.pumpAndSettle();

        // Entering data
        final input = find.byType(TextFormField);

        await tester.enterText(input.at(0), 'x-4.678');
        await tester.enterText(input.at(1), '4');
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.byKey(const Key('Nonlinear-button-solve')), -30);
        await tester.pumpAndSettle();

        await tester.drag(find.byType(Slider).first, const Offset(60, 0));
        await tester.pumpAndSettle();

        // Solving
        await tester.tap(find.byKey(const Key('Nonlinear-button-solve')));
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsNWidgets(3));
        expect(find.byType(Slider), findsNWidgets(2));

        // Clearing
        await tester.tap(find.byKey(const Key('Nonlinear-button-clean')));
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsNothing);
        expect(find.byType(Slider), findsOneWidget);
      },
    );

    testWidgets('Making sure that bracketing equations can be solved',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Opening the 'Polynomial' solver and going to 'Quadratic'
      await tester.tap(find.byType(NonlinearLogo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bracketing'));
      await tester.pumpAndSettle();

      // Entering data
      final input = find.byType(TextFormField);

      await tester.enterText(input.at(0), 'x-4.678');
      await tester.enterText(input.at(1), '4');
      await tester.enterText(input.at(2), '5.2');
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byKey(const Key('Nonlinear-button-solve')), -30);
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Slider).first, const Offset(60, 0));
      await tester.pumpAndSettle();

      // Solving
      await tester.tap(find.byKey(const Key('Nonlinear-button-solve')));
      await tester.pumpAndSettle();

      expect(find.byType(RealResultCard), findsNWidgets(3));
      expect(find.byType(Slider), findsNWidgets(2));

      // Clearing
      await tester.tap(find.byKey(const Key('Nonlinear-button-clean')));
      await tester.pumpAndSettle();

      expect(find.byType(RealResultCard), findsNothing);
      expect(find.byType(Slider), findsOneWidget);
    },);
  });
}
