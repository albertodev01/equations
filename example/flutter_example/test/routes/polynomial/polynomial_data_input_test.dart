import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final List<BlocProvider> providers;
  late final PolynomialBloc polynomialBloc;

  setUpAll(() {
    registerFallbackValue<PolynomialEvent>(MockPolynomialEvent());
    registerFallbackValue<PolynomialState>(MockPolynomialState());

    polynomialBloc = MockPolynomialBloc();

    providers = [
      BlocProvider<PolynomialBloc>.value(
        value: polynomialBloc,
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

  group("Testing the 'PolynomialDataInput' widget", () {
    testWidgets(
        "Making sure that with a 'linear' configuration type only "
        '2 input fields appear on the screen', (tester) async {
      when(() => polynomialBloc.polynomialType)
          .thenReturn(PolynomialType.linear);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: providers,
          child: const Scaffold(body: PolynomialDataInput()),
        ),
      ));

      expect(find.byType(PolynomialDataInput), findsOneWidget);
      expect(find.byType(PolynomialInputField), findsNWidgets(2));

      // To make sure that fields validation actually happens
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets(
        "Making sure that with a 'quadratic' configuration type only "
        '3 input fields appear on the screen', (tester) async {
      when(() => polynomialBloc.polynomialType)
          .thenReturn(PolynomialType.quadratic);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: providers,
          child: const Scaffold(body: PolynomialDataInput()),
        ),
      ));

      expect(find.byType(PolynomialDataInput), findsOneWidget);
      expect(find.byType(PolynomialInputField), findsNWidgets(3));

      // To make sure that fields validation actually happens
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets(
        "Making sure that with a 'cubic' configuration type only "
        '4 input fields appear on the screen', (tester) async {
      when(() => polynomialBloc.polynomialType)
          .thenReturn(PolynomialType.cubic);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: providers,
          child: const Scaffold(body: PolynomialDataInput()),
        ),
      ));

      expect(find.byType(PolynomialDataInput), findsOneWidget);
      expect(find.byType(PolynomialInputField), findsNWidgets(4));

      // To make sure that fields validation actually happens
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets(
        "Making sure that with a 'cubic' configuration type only "
        '5 input fields appear on the screen', (tester) async {
      when(() => polynomialBloc.polynomialType)
          .thenReturn(PolynomialType.quartic);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: providers,
          child: const Scaffold(body: PolynomialDataInput()),
        ),
      ));

      expect(find.byType(PolynomialDataInput), findsOneWidget);
      expect(find.byType(PolynomialInputField), findsNWidgets(5));

      // To make sure that fields validation actually happens
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets(
        'Making sure that when trying to solve an equation, if at '
        'least one of the inputs is wrong, a snackbar appears', (tester) async {
      when(() => polynomialBloc.polynomialType)
          .thenReturn(PolynomialType.linear);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: providers,
          child: const Scaffold(body: PolynomialDataInput()),
        ),
      ));

      // No snackbar by default
      expect(find.byType(SnackBar), findsNothing);

      // Tap the 'Solve' button
      final finder = find.byKey(const Key('Polynomial-button-solve'));
      await tester.tap(finder);

      // The snackbar appeared
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Making sure that equations can be solved', (tester) async {
      final bloc = PolynomialBloc(PolynomialType.quadratic);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: providers,
          child: Scaffold(
            body: BlocProvider<PolynomialBloc>.value(
              value: bloc,
              child: const PolynomialDataInput(),
            ),
          ),
        ),
      ));

      final coeffA =
          find.byKey(const Key('PolynomialInputField-coefficient-0'));
      final coeffB =
          find.byKey(const Key('PolynomialInputField-coefficient-1'));
      final coeffC =
          find.byKey(const Key('PolynomialInputField-coefficient-2'));
      final solveButton = find.byKey(const Key('Polynomial-button-solve'));

      // Filling the forms
      await tester.enterText(coeffA, '-5');
      await tester.enterText(coeffB, '1/2');
      await tester.enterText(coeffC, '3');

      // Making sure that there are no results
      expect(bloc.state, isA<PolynomialNone>());

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Sending it to the bloc
      expect(bloc.state, isA<PolynomialRoots>());
    });
  });
}
