import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';
import 'system_page/system_mock.dart';

void main() {
  group("Testing the 'SystemPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: SystemPage(),
        ),
      );

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
      await tester.pumpWidget(
        MockWrapper(
          child: Builder(
            builder: (context) {
              rowReduction = context.l10n.row_reduction;
              factorization = context.l10n.factorization;
              iterative = context.l10n.iterative;

              return const SystemPage();
            },
          ),
        ),
      );

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

  group('Golden tests - SystemBody', () {
    Future<void> solveSystem(
      WidgetTester tester, {
      SystemType systemType = SystemType.rowReduction,
    }) async {
      if (systemType == SystemType.iterative) {
        await tester.enterText(
          find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
          '1',
        );
        await tester.pumpAndSettle();
      }

      await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
      await tester.enterText(find.byKey(const Key('VectorEntry-0')), '1');

      final solveButton = find.byKey(const Key('System-button-solve'));

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();
    }

    testWidgets('SystemBody - row reduction', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));

      await tester.pumpWidget(
        const MockSystemWidget(),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/system_body_rowreduction.png'),
      );
    });

    testWidgets('SystemBody - row reduction with solution', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));

      await tester.pumpWidget(
        const MockSystemWidget(),
      );

      await solveSystem(tester);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/system_body_rowreduction_solution.png'),
      );
    });

    testWidgets('SystemBody - factorization', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));

      await tester.pumpWidget(
        MockSystemWidget(
          dropdownValue: SystemDropdownItems.lu.asString(),
          systemType: SystemType.factorization,
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/system_body_factorization.png'),
      );
    });

    testWidgets('SystemBody - factorization with solution', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 950));

      await tester.pumpWidget(
        MockSystemWidget(
          dropdownValue: SystemDropdownItems.lu.asString(),
          systemType: SystemType.factorization,
        ),
      );

      await solveSystem(tester, systemType: SystemType.factorization);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/system_body_factorization_solution.png'),
      );
    });

    testWidgets('SystemBody - iterative', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1050));

      await tester.pumpWidget(
        MockSystemWidget(
          dropdownValue: SystemDropdownItems.sor.asString(),
          systemType: SystemType.iterative,
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/system_body_iterative.png'),
      );
    });

    testWidgets('SystemBody - iterative with solution', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1100));

      await tester.pumpWidget(
        MockSystemWidget(
          dropdownValue: SystemDropdownItems.sor.asString(),
          systemType: SystemType.iterative,
        ),
      );

      await solveSystem(tester, systemType: SystemType.iterative);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/system_body_iterative_solution.png'),
      );
    });
  });
}
