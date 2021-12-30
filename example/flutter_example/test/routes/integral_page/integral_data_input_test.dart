import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final DropdownCubit dropdownCubit;

  setUpAll(() {
    dropdownCubit = MockDropdownCubit();
  });

  group("Testing the 'IntegralDataInput' widget", () {
    testWidgets(
      'Making sure that when trying to evaluate an integral, if at least one '
      'of the inputs is wrong, a snackbar appears',
      (tester) async {
        final integralBloc = IntegralBloc();

        when(() => dropdownCubit.state)
            .thenReturn(IntegralDropdownItems.simpson.asString());

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DropdownCubit>.value(
                value: dropdownCubit,
              ),
              BlocProvider<IntegralBloc>.value(
                value: integralBloc,
              ),
            ],
            child: const Scaffold(
              body: IntegralDataInput(),
            ),
          ),
        ));

        // No snackbar by default
        expect(find.byType(SnackBar), findsNothing);

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);

        // The snackbar appeared
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
        expect(integralBloc.state, isA<IntegralNone>());
      },
    );

    testWidgets(
      'Making sure that fields can be cleared',
      (tester) async {
        late FocusScopeNode focusScope;
        final integralBloc = IntegralBloc();

        when(() => dropdownCubit.state)
            .thenReturn(IntegralDropdownItems.simpson.asString());

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DropdownCubit>.value(
                value: dropdownCubit,
              ),
              BlocProvider<IntegralBloc>.value(
                value: integralBloc,
              ),
            ],
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  focusScope = FocusScope.of(context);

                  return IntegralDataInput();
                },
              ),
            ),
          ),
        ));

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '17');
        await tester.enterText(upperInput, '18');

        // Making sure that fields are filled
        expect(find.text('x^2-1'), findsOneWidget);
        expect(find.text('17'), findsOneWidget);
        expect(find.text('18'), findsOneWidget);
        expect(focusScope.hasFocus, isTrue);

        // Tap the 'Clear' button
        final finder = find.byKey(const Key('Integral-button-clean'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Making sure that fields have been cleared
        expect(find.text('x^2-1'), findsNothing);
        expect(find.text('17'), findsNothing);
        expect(find.text('18'), findsNothing);
        expect(focusScope.hasFocus, isFalse);

        tester
            .widgetList<TextFormField>(find.byType(TextFormField))
            .forEach((t) {
          expect(t.controller!.text.length, isZero);
        });
      },
    );

    testWidgets(
      'Making sure that integrals can be evaluated using the Simpson method',
      (tester) async {
        final integralBloc = IntegralBloc();

        when(() => dropdownCubit.state)
            .thenReturn(IntegralDropdownItems.simpson.asString());

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DropdownCubit>.value(
                value: dropdownCubit,
              ),
              BlocProvider<IntegralBloc>.value(
                value: integralBloc,
              ),
            ],
            child: const Scaffold(
              body: IntegralDataInput(),
            ),
          ),
        ));

        expect(find.byType(RealResultCard), findsNothing);

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '2');
        await tester.enterText(upperInput, '5');

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(integralBloc.state, isA<IntegralResult>());
      },
    );

    testWidgets(
      'Making sure that integrals can be evaluated using the Midpoint rule',
      (tester) async {
        final integralBloc = IntegralBloc();

        when(() => dropdownCubit.state)
            .thenReturn(IntegralDropdownItems.midpoint.asString());

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DropdownCubit>.value(
                value: dropdownCubit,
              ),
              BlocProvider<IntegralBloc>.value(
                value: integralBloc,
              ),
            ],
            child: const Scaffold(
              body: IntegralDataInput(),
            ),
          ),
        ));

        expect(find.byType(RealResultCard), findsNothing);

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '2');
        await tester.enterText(upperInput, '5');

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(integralBloc.state, isA<IntegralResult>());
      },
    );

    testWidgets(
      'Making sure that integrals can be evaluated using the Trapezoid rule',
      (tester) async {
        final integralBloc = IntegralBloc();

        when(() => dropdownCubit.state)
            .thenReturn(IntegralDropdownItems.trapezoid.asString());

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DropdownCubit>.value(
                value: dropdownCubit,
              ),
              BlocProvider<IntegralBloc>.value(
                value: integralBloc,
              ),
            ],
            child: const Scaffold(
              body: IntegralDataInput(),
            ),
          ),
        ));

        expect(find.byType(RealResultCard), findsNothing);

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '2');
        await tester.enterText(upperInput, '5');

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(integralBloc.state, isA<IntegralResult>());
      },
    );

    testGoldens('IntegralDataInput', (tester) async {
      final integralBloc = IntegralBloc();

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Simpson',
          Builder(builder: (context) {
            when(() => dropdownCubit.state)
                .thenReturn(IntegralDropdownItems.simpson.asString());

            return MultiBlocProvider(
              providers: [
                BlocProvider<DropdownCubit>.value(
                  value: dropdownCubit,
                ),
                BlocProvider<IntegralBloc>.value(
                  value: integralBloc,
                ),
              ],
              child: const IntegralDataInput(),
            );
          }),
        )
        ..addScenario(
          'Trapezoid',
          Builder(builder: (context) {
            when(() => dropdownCubit.state)
                .thenReturn(IntegralDropdownItems.trapezoid.asString());

            return MultiBlocProvider(
              providers: [
                BlocProvider<DropdownCubit>.value(
                  value: dropdownCubit,
                ),
                BlocProvider<IntegralBloc>.value(
                  value: integralBloc,
                ),
              ],
              child: const IntegralDataInput(),
            );
          }),
        )
        ..addScenario(
          'Midpoint',
          Builder(builder: (context) {
            when(() => dropdownCubit.state)
                .thenReturn(IntegralDropdownItems.midpoint.asString());

            return MultiBlocProvider(
              providers: [
                BlocProvider<DropdownCubit>.value(
                  value: dropdownCubit,
                ),
                BlocProvider<IntegralBloc>.value(
                  value: integralBloc,
                ),
              ],
              child: const IntegralDataInput(),
            );
          }),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(600, 1300),
      );
      await screenMatchesGolden(tester, 'integral_input_data');
    });
  });
}
