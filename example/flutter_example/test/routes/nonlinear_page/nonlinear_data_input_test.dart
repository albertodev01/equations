import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final List<BlocProvider> providers;
  late final NonlinearBloc nonlinearBloc;
  late final DropdownCubit dropdownCubit;

  setUpAll(() {
    registerFallbackValue(MockNonlinearEvent());
    registerFallbackValue(MockNonlinearState());

    nonlinearBloc = MockNonlinearBloc();
    dropdownCubit = MockDropdownCubit();

    providers = [
      BlocProvider<NonlinearBloc>.value(
        value: nonlinearBloc,
      ),
      BlocProvider<DropdownCubit>.value(
        value: dropdownCubit,
      ),
      BlocProvider<SliderCubit>(
        create: (_) => SliderCubit(
          minValue: 1,
          maxValue: 10,
          current: 5,
        ),
      ),
    ];
  });

  group("Testing the 'NonlinearDataInput' widget", () {
    testWidgets(
      "Making sure that with a 'singlePoint' configuration type only "
      'has 2 input fields appear on the screen',
      (tester) async {
        when(() => dropdownCubit.state).thenReturn('Newton');
        when(() => nonlinearBloc.nonlinearType)
            .thenReturn(NonlinearType.singlePoint);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: providers,
            child: const Scaffold(body: NonlinearDataInput()),
          ),
        ));

        expect(find.byType(NonlinearDataInput), findsOneWidget);
        expect(find.byType(EquationInput), findsNWidgets(2));
        expect(find.byType(NonlinearDropdownSelection), findsOneWidget);
        expect(find.byType(PrecisionSlider), findsOneWidget);

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that with a 'bracketing' configuration type only "
      'has 3 input fields appear on the screen',
      (tester) async {
        when(() => dropdownCubit.state).thenReturn('Secant');
        when(() => nonlinearBloc.nonlinearType)
            .thenReturn(NonlinearType.bracketing);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: providers,
            child: const Scaffold(body: NonlinearDataInput()),
          ),
        ));

        expect(find.byType(NonlinearDataInput), findsOneWidget);
        expect(find.byType(EquationInput), findsNWidgets(3));
        expect(find.byType(NonlinearDropdownSelection), findsOneWidget);
        expect(find.byType(PrecisionSlider), findsOneWidget);

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that when trying to solve an equation, if at '
      'least one of the inputs is wrong, a snackbar appears',
      (tester) async {
        when(() => dropdownCubit.state).thenReturn('Secant');
        when(() => nonlinearBloc.nonlinearType)
            .thenReturn(NonlinearType.bracketing);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: providers,
            child: const Scaffold(body: NonlinearDataInput()),
          ),
        ));

        // No snackbar by default
        expect(find.byType(SnackBar), findsNothing);

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Nonlinear-button-solve'));
        await tester.tap(finder);

        // The snackbar appeared
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that single point equations can be solved',
      (tester) async {
        when(() => dropdownCubit.state).thenReturn('Newton');
        final bloc = NonlinearBloc(NonlinearType.singlePoint);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: providers,
            child: Scaffold(
              body: BlocProvider<NonlinearBloc>.value(
                value: bloc,
                child: const NonlinearDataInput(),
              ),
            ),
          ),
        ));

        final equationInput = find.byKey(const Key('EquationInput-function'));
        final paramInput = find.byKey(const Key('EquationInput-first-param'));
        final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

        // Filling the forms
        await tester.enterText(equationInput, 'x-3');
        await tester.enterText(paramInput, '3');

        // Making sure that there are no results
        expect(bloc.state, isA<NonlinearNone>());

        // Solving the equation
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        // Sending it to the bloc
        expect(bloc.state, isA<NonlinearGuesses>());
      },
    );

    testWidgets(
      'Making sure that bracketing equations can be solved',
      (tester) async {
        when(() => dropdownCubit.state).thenReturn('Bisection');
        final bloc = NonlinearBloc(NonlinearType.bracketing);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: providers,
            child: Scaffold(
              body: BlocProvider<NonlinearBloc>.value(
                value: bloc,
                child: const NonlinearDataInput(),
              ),
            ),
          ),
        ));

        final equationInput = find.byKey(const Key('EquationInput-function'));
        final paramInput1 = find.byKey(const Key('EquationInput-first-param'));
        final paramInput2 = find.byKey(const Key('EquationInput-second-param'));
        final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

        // Filling the forms
        await tester.enterText(equationInput, 'x-3');
        await tester.enterText(paramInput1, '1');
        await tester.enterText(paramInput2, '4');

        // Making sure that there are no results
        expect(bloc.state, isA<NonlinearNone>());

        // Solving the equation
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        // Sending it to the bloc
        expect(bloc.state, isA<NonlinearGuesses>());
      },
    );

    testWidgets('Making sure that textfields can be cleared', (tester) async {
      when(() => dropdownCubit.state).thenReturn('Newton');
      final bloc = NonlinearBloc(NonlinearType.singlePoint);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: providers,
          child: Scaffold(
            body: BlocProvider<NonlinearBloc>.value(
              value: bloc,
              child: const NonlinearDataInput(),
            ),
          ),
        ),
      ));

      expect(find.byType(NonlinearDataInput), findsOneWidget);

      await tester.tap(find.byKey(const Key('Nonlinear-button-clean')));
      await tester.pumpAndSettle();

      expect(bloc.state, equals(const NonlinearNone()));
    });

    testGoldens('NonlinearDataInput - Single point', (tester) async {
      when(() => dropdownCubit.state).thenReturn('Newton');
      final bloc = NonlinearBloc(NonlinearType.singlePoint);

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Single point',
          SizedBox(
            width: 600,
            height: 650,
            child: MultiBlocProvider(
              providers: providers,
              child: BlocProvider<NonlinearBloc>.value(
                value: bloc,
                child: const NonlinearDataInput(),
              ),
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(600, 750),
      );
      await screenMatchesGolden(tester, 'nonlinear_input_data_single_point');
    });

    testGoldens('NonlinearDataInput - Bracketing', (tester) async {
      when(() => dropdownCubit.state).thenReturn('Bisection');
      final bloc = NonlinearBloc(NonlinearType.bracketing);

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Bracketing',
          SizedBox(
            width: 600,
            height: 650,
            child: MultiBlocProvider(
              providers: providers,
              child: BlocProvider<NonlinearBloc>.value(
                value: bloc,
                child: const NonlinearDataInput(),
              ),
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(600, 750),
      );
      await screenMatchesGolden(tester, 'nonlinear_input_data_bracketing');
    });
  });
}
