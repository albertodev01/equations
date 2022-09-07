import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_data_input.dart';
import 'package:equations_solver/routes/system_page/system_results.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'system_mock.dart';

void main() {
  group("Testing the 'SystemBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockSystemWidget(),
      );

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(SystemDataInput), findsOneWidget);
      expect(find.byType(SystemResults), findsOneWidget);
      expect(find.byType(PageTitle), findsOneWidget);
      expect(find.byType(SystemsLogo), findsOneWidget);
    });

    testWidgets(
      'Making sure that the "Clear" button actually clears the state',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString,
          ),
        );

        // Filling the matrix with some data
        await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
        await tester.enterText(find.byKey(const Key('VectorEntry-0')), '1');
        expect(find.byType(RealResultCard), findsNothing);

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);

        // Clearing the page
        await tester.tap(find.byKey(const Key('System-button-clean')));
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsNothing);
        tester.widgetList<TextFormField>(find.byType(TextFormField)).forEach(
          (widget) {
            expect(widget.controller!.text.length, isZero);
          },
        );
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations using the row reduction algorithm',
      (tester) async {
        await tester.pumpWidget(
          const MockSystemWidget(),
        );

        await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
        await tester.enterText(find.byKey(const Key('VectorEntry-0')), '1');
        expect(find.byType(RealResultCard), findsNothing);

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with a factorization method (LU)',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString,
          ),
        );

        // Filling the matrix with some data
        await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
        await tester.enterText(find.byKey(const Key('VectorEntry-0')), '1');

        expect(find.byType(RealResultCard), findsNothing);

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with a factorization method (Cholesky)',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.cholesky.asString,
          ),
        );

        // Filling the matrix with some data
        await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
        await tester.enterText(find.byKey(const Key('VectorEntry-0')), '1');

        expect(find.byType(RealResultCard), findsNothing);

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with an iterative method (SOR)',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.iterative,
            dropdownValue: SystemDropdownItems.sor.asString,
          ),
        );

        // Filling the matrix with some data
        await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
        await tester.enterText(find.byKey(const Key('VectorEntry-0')), '1');
        await tester.enterText(
          find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
          '1',
        );

        expect(find.byType(RealResultCard), findsNothing);

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with an iterative method (Jacobi)',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.iterative,
            dropdownValue: SystemDropdownItems.jacobi.asString,
          ),
        );

        // Filling the matrix with some data
        await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
        await tester.enterText(
          find.byKey(const Key('VectorEntry-0')).first,
          '1',
        );
        await tester.enterText(
          find.byKey(const Key('VectorEntry-0')).last,
          '1',
        );

        expect(find.byType(RealResultCard), findsNothing);

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the "Solve" button does NOT solve the '
      'system in case of malformed input',
      (tester) async {
        await tester.pumpWidget(
          const MockSystemWidget(),
        );

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the number switcher also changes the total '
      'number of input tiles on the screen',
      (tester) async {
        await tester.pumpWidget(
          const MockSystemWidget(),
        );

        expect(find.byKey(const Key('SystemEntry-0-0')), findsOneWidget);
        expect(find.byKey(const Key('VectorEntry-0')), findsOneWidget);

        // Changing the size
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('SystemEntry-0-0')), findsOneWidget);
        expect(find.byKey(const Key('SystemEntry-0-1')), findsOneWidget);
        expect(find.byKey(const Key('SystemEntry-1-0')), findsOneWidget);
        expect(find.byKey(const Key('SystemEntry-1-1')), findsOneWidget);
        expect(find.byKey(const Key('VectorEntry-0')), findsOneWidget);
        expect(find.byKey(const Key('VectorEntry-1')), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the number switcher also clears everything when '
      'changing values',
      (tester) async {
        await tester.pumpWidget(
          const MockSystemWidget(),
        );

        await tester.enterText(find.byKey(const Key('SystemEntry-0-0')), '1');
        await tester.enterText(find.byKey(const Key('VectorEntry-0')), '1');
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('System-button-solve')));
        await tester.pumpAndSettle();

        expect(find.text('1'), findsNWidgets(3));
        expect(find.byType(RealResultCard), findsOneWidget);

        // Changing the size
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.pumpAndSettle();

        // Making sure the form is clean
        expect(find.text('1'), findsNothing);
        expect(find.byType(RealResultCard), findsNothing);
      },
    );
  });
}
