import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/routes/system_page/system_data_input.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final SystemBloc systemBloc;
  late final NumberSwitcherCubit numberSwitcherCubit;
  late final DropdownCubit dropdownCubit;
  late final Widget widgetWithMocks;

  setUpAll(() {
    registerFallbackValue(MockSystemEvent());
    registerFallbackValue(MockSystemState());

    systemBloc = MockSystemBloc();
    dropdownCubit = MockDropdownCubit();
    numberSwitcherCubit = MockNumberSwitcherCubit();

    widgetWithMocks = SingleChildScrollView(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SystemBloc>.value(value: systemBloc),
          BlocProvider<NumberSwitcherCubit>.value(value: numberSwitcherCubit),
          BlocProvider<DropdownCubit>.value(value: dropdownCubit),
        ],
        child: const SystemDataInput(),
      ),
    );
  });

  group("Testing the 'SystemDataInput' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      when(() => systemBloc.systemType).thenReturn(SystemType.factorization);
      when(() => numberSwitcherCubit.state).thenReturn(2);
      when(() => dropdownCubit.state)
          .thenReturn(SystemDropdownItems.lu.asString());

      await tester.pumpWidget(MockWrapper(
        dropdownInitial: SystemDropdownItems.lu.asString(),
        child: widgetWithMocks,
      ));

      expect(find.byType(SystemDataInput), findsOneWidget);
      expect(find.byType(SizePicker), findsOneWidget);
      expect(find.byType(MatrixInput), findsOneWidget);
      expect(find.byType(VectorInput), findsOneWidget);
      expect(find.byType(SystemDropdownSelection), findsOneWidget);

      expect(find.byKey(const Key('System-button-solve')), findsOneWidget);
      expect(find.byKey(const Key('System-button-clean')), findsOneWidget);
    });

    testWidgets(
      'Making sure that the "Clear" button actually clears the '
      'text controllers and the bloc',
      (tester) async {
        late FocusScopeNode focusScope;

        when(() => numberSwitcherCubit.state).thenReturn(2);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.lu.asString());

        final bloc = SystemBloc(SystemType.factorization);

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: bloc),
                BlocProvider<NumberSwitcherCubit>.value(
                  value: numberSwitcherCubit,
                ),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: Builder(
                builder: (context) {
                  focusScope = FocusScope.of(context);

                  return const SystemDataInput();
                },
              ),
            ),
          ),
        ));

        expect(bloc.state, equals(const SystemNone()));

        // Entering some text to make sure that there is focus
        await tester.enterText(find.byType(TextFormField).first, '1');
        expect(focusScope.hasFocus, isTrue);

        // Cleaning
        final clearButton = find.byKey(const Key('System-button-clean'));

        await tester.ensureVisible(clearButton);
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        expect(bloc.state, equals(const SystemNone()));
        expect(focusScope.hasFocus, isFalse);

        tester
            .widgetList<TextFormField>(find.byType(TextFormField))
            .forEach((t) {
          expect(t.controller!.text.length, isZero);
        });
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with a row reduction method',
      (tester) async {
        when(() => numberSwitcherCubit.state).thenReturn(2);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.lu.asString());

        final bloc = SystemBloc(SystemType.rowReduction);

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: bloc),
                BlocProvider<NumberSwitcherCubit>.value(
                  value: numberSwitcherCubit,
                ),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDataInput(),
            ),
          ),
        ));

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.matrixControllers.first.text = '1';
        state.matrixControllers[1].text = '2';
        state.matrixControllers[2].text = '3';
        state.matrixControllers[3].text = '4';
        state.vectorControllers.first.text = '7';
        state.vectorControllers[1].text = '8';

        expect(bloc.state, equals(const SystemNone()));

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(bloc.state, isA<SystemGuesses>());
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with a factorization method (LU)',
      (tester) async {
        when(() => numberSwitcherCubit.state).thenReturn(2);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.lu.asString());

        final bloc = SystemBloc(SystemType.factorization);

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: bloc),
                BlocProvider<NumberSwitcherCubit>.value(
                  value: numberSwitcherCubit,
                ),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDataInput(),
            ),
          ),
        ));

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.matrixControllers.first.text = '1';
        state.matrixControllers[1].text = '2';
        state.matrixControllers[2].text = '3';
        state.matrixControllers[3].text = '4';
        state.vectorControllers.first.text = '7';
        state.vectorControllers[1].text = '8';

        expect(bloc.state, equals(const SystemNone()));

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(bloc.state, isA<SystemGuesses>());
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with a factorization method (Cholesky)',
      (tester) async {
        when(() => numberSwitcherCubit.state).thenReturn(2);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.cholesky.asString());

        final bloc = SystemBloc(SystemType.factorization);

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: bloc),
                BlocProvider<NumberSwitcherCubit>.value(
                  value: numberSwitcherCubit,
                ),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDataInput(),
            ),
          ),
        ));

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.matrixControllers.first.text = '4';
        state.matrixControllers[1].text = '12';
        state.matrixControllers[2].text = '12';
        state.matrixControllers[3].text = '26';
        state.vectorControllers.first.text = '4';
        state.vectorControllers[1].text = '6';

        expect(bloc.state, equals(const SystemNone()));

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(bloc.state, isA<SystemGuesses>());
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with an iterative method (SOR)',
      (tester) async {
        when(() => numberSwitcherCubit.state).thenReturn(2);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.sor.asString());

        final bloc = SystemBloc(SystemType.iterative);

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: bloc),
                BlocProvider<NumberSwitcherCubit>.value(
                  value: numberSwitcherCubit,
                ),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDataInput(),
            ),
          ),
        ));

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.matrixControllers.first.text = '1';
        state.matrixControllers[1].text = '2';
        state.matrixControllers[2].text = '3';
        state.matrixControllers[3].text = '4';
        state.vectorControllers.first.text = '7';
        state.vectorControllers[1].text = '8';
        state.wSorController.text = '1';

        expect(bloc.state, equals(const SystemNone()));

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(bloc.state, isA<SystemGuesses>());
      },
    );

    testWidgets(
      'Making sure that the "Solve" button actually solves the '
      'system of equations with an iterative method (Jacobi)',
      (tester) async {
        when(() => numberSwitcherCubit.state).thenReturn(2);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.jacobi.asString());

        final bloc = SystemBloc(SystemType.iterative);

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: bloc),
                BlocProvider<NumberSwitcherCubit>.value(
                  value: numberSwitcherCubit,
                ),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDataInput(),
            ),
          ),
        ));

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.matrixControllers.first.text = '1';
        state.matrixControllers[1].text = '2';
        state.matrixControllers[2].text = '3';
        state.matrixControllers[3].text = '4';
        state.vectorControllers.first.text = '7';
        state.vectorControllers[1].text = '8';
        state.jacobiControllers.first.text = '-5';
        state.jacobiControllers[1].text = '7';

        expect(bloc.state, equals(const SystemNone()));

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(bloc.state, isA<SystemGuesses>());
      },
    );

    testWidgets(
      'Making sure that the "Solve" button does NOT solve the '
      'system in case of malformed input',
      (tester) async {
        when(() => numberSwitcherCubit.state).thenReturn(2);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.lu.asString());

        final bloc = SystemBloc(SystemType.rowReduction);

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: bloc),
                BlocProvider<NumberSwitcherCubit>.value(
                  value: numberSwitcherCubit,
                ),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDataInput(),
            ),
          ),
        ));

        // Filling the matrix with some data
        final widget = find.byType(SystemDataInput);
        final state = tester.state<SystemDataInputState>(widget);

        state.matrixControllers.first.text = '1';
        state.matrixControllers[1].text = '2';
        state.matrixControllers[2].text = '';
        state.matrixControllers[3].text = '4';
        state.vectorControllers.first.text = 'abc';
        state.vectorControllers[1].text = '8';

        expect(bloc.state, equals(const SystemNone()));

        // Solving the system
        final solveButton = find.byKey(const Key('System-button-solve'));

        await tester.ensureVisible(solveButton);
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(bloc.state, equals(const SystemNone()));
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the number switcher also changes the total '
      'number of input tiles on the screen',
      (tester) async {
        when(() => systemBloc.systemType).thenReturn(SystemType.factorization);
        when(() => dropdownCubit.state)
            .thenReturn(SystemDropdownItems.lu.asString());

        final bloc = NumberSwitcherCubit(
          min: 2,
          max: 4,
        );

        await tester.pumpWidget(MockWrapper(
          child: SingleChildScrollView(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: systemBloc),
                BlocProvider<NumberSwitcherCubit>.value(value: bloc),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDataInput(),
            ),
          ),
        ));

        expect(bloc.state, equals(2));

        // 4 (2*2) for the matrix and 2 for the vector
        expect(find.byType(SystemInputField), findsNWidgets(6));

        // Changing the size
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.pumpAndSettle();

        // 9 (3*3) for the matrix and 3 for the vector
        expect(find.byType(SystemInputField), findsNWidgets(12));
      },
    );

    testGoldens('SystemDataInput - Factorization', (tester) async {
      when(() => systemBloc.systemType).thenReturn(SystemType.factorization);
      when(() => numberSwitcherCubit.state).thenReturn(2);
      when(() => dropdownCubit.state)
          .thenReturn(SystemDropdownItems.lu.asString());

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Factorization method',
          SizedBox(
            width: 500,
            height: 800,
            child: widgetWithMocks,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(530, 870),
      );
      await screenMatchesGolden(tester, 'system_data_input_factorization');
    });

    testGoldens('SystemDataInput - Factorization', (tester) async {
      when(() => systemBloc.systemType).thenReturn(SystemType.rowReduction);
      when(() => numberSwitcherCubit.state).thenReturn(2);
      when(() => dropdownCubit.state)
          .thenReturn(SystemDropdownItems.lu.asString());

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Row reduction method',
          SizedBox(
            width: 500,
            height: 800,
            child: widgetWithMocks,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(530, 870),
      );
      await screenMatchesGolden(tester, 'system_data_input_row_reduction');
    });

    testGoldens('SystemDataInput - Iterative - SOR', (tester) async {
      when(() => systemBloc.systemType).thenReturn(SystemType.iterative);
      when(() => numberSwitcherCubit.state).thenReturn(2);
      when(() => dropdownCubit.state)
          .thenReturn(SystemDropdownItems.sor.asString());

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Iterative method (SOR)',
          SizedBox(
            width: 500,
            height: 900,
            child: widgetWithMocks,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(530, 970),
      );
      await screenMatchesGolden(tester, 'system_data_input_sor');
    });

    testGoldens('SystemDataInput - Iterative - Jacobi', (tester) async {
      when(() => systemBloc.systemType).thenReturn(SystemType.iterative);
      when(() => numberSwitcherCubit.state).thenReturn(2);
      when(() => dropdownCubit.state)
          .thenReturn(SystemDropdownItems.jacobi.asString());

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Iterative method (Jacobi)',
          SizedBox(
            width: 500,
            height: 800,
            child: widgetWithMocks,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(530, 870),
      );
      await screenMatchesGolden(tester, 'system_data_input_jacobi');
    });
  });
}
