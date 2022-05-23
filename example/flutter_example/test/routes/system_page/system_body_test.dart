import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
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
            dropdownValue: SystemDropdownItems.lu.asString(),
          ),
        );

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.context.systemTextControllers.matrixControllers.first.text = '1';
        state.context.systemTextControllers.matrixControllers[1].text = '2';
        state.context.systemTextControllers.matrixControllers[2].text = '3';
        state.context.systemTextControllers.matrixControllers[3].text = '4';
        state.context.systemTextControllers.vectorControllers.first.text = '7';
        state.context.systemTextControllers.vectorControllers[1].text = '8';

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
      'system of equations with a factorization method (LU)',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString(),
          ),
        );

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.context.systemTextControllers.matrixControllers.first.text = '1';
        state.context.systemTextControllers.matrixControllers[1].text = '2';
        state.context.systemTextControllers.matrixControllers[2].text = '3';
        state.context.systemTextControllers.matrixControllers[3].text = '4';
        state.context.systemTextControllers.vectorControllers.first.text = '7';
        state.context.systemTextControllers.vectorControllers[1].text = '8';

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
            dropdownValue: SystemDropdownItems.cholesky.asString(),
          ),
        );

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.context.systemTextControllers.matrixControllers.first.text = '4';
        state.context.systemTextControllers.matrixControllers[1].text = '12';
        state.context.systemTextControllers.matrixControllers[2].text = '12';
        state.context.systemTextControllers.matrixControllers[3].text = '26';
        state.context.systemTextControllers.vectorControllers.first.text = '4';
        state.context.systemTextControllers.vectorControllers[1].text = '6';

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
            dropdownValue: SystemDropdownItems.sor.asString(),
          ),
        );

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.context.systemTextControllers.matrixControllers.first.text = '4';
        state.context.systemTextControllers.matrixControllers[1].text = '12';
        state.context.systemTextControllers.matrixControllers[2].text = '12';
        state.context.systemTextControllers.matrixControllers[3].text = '26';
        state.context.systemTextControllers.vectorControllers.first.text = '4';
        state.context.systemTextControllers.vectorControllers[1].text = '6';
        state.context.systemTextControllers.wSorController.text = '1';

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
            dropdownValue: SystemDropdownItems.jacobi.asString(),
          ),
        );

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.context.systemTextControllers.matrixControllers.first.text = '1';
        state.context.systemTextControllers.matrixControllers[1].text = '2';
        state.context.systemTextControllers.matrixControllers[2].text = '3';
        state.context.systemTextControllers.matrixControllers[3].text = '4';
        state.context.systemTextControllers.vectorControllers.first.text = '7';
        state.context.systemTextControllers.vectorControllers[1].text = '8';
        state.context.systemTextControllers.jacobiControllers.first.text = '-5';
        state.context.systemTextControllers.jacobiControllers[1].text = '7';

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
  });
}
