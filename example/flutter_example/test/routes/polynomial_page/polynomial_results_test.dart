import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/bloc/events.dart';
import 'package:equations_solver/blocs/polynomial_solver/bloc/states.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/polynomial_page/utils/complex_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final MockPolynomialBloc polynomialBloc;

  setUpAll(() {
    registerFallbackValue<PolynomialEvent>(MockPolynomialEvent());
    registerFallbackValue<PolynomialState>(MockPolynomialState());

    polynomialBloc = MockPolynomialBloc();
  });

  group("Testing the 'PolynomialResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<PolynomialBloc>(
          create: (_) => PolynomialBloc(PolynomialType.linear),
          child: const PolynomialResults(),
        ),
      ));

      expect(find.byType(PolynomialResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsNWidgets(2));
    });

    testWidgets(
        'Making sure that, when there are no solutions, a text widget '
        "appears saying that there's nothing to display", (tester) async {
      when(() => polynomialBloc.state).thenReturn(const PolynomialNone());

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<PolynomialBloc>.value(
          value: polynomialBloc,
          child: const PolynomialResults(),
        ),
      ));

      expect(find.byType(ListView), findsNothing);
      expect(find.text('No solutions to display.'), findsOneWidget);
    });

    testWidgets(
        'Making sure that, when there are solutions, solution widgets '
        'appear on the screen', (tester) async {
      final linear = Algebraic.fromReal(const [1, 2]);

      when(() => polynomialBloc.state).thenReturn(PolynomialRoots(
        algebraic: linear,
        roots: linear.solutions(),
        discriminant: linear.discriminant(),
      ));

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<PolynomialBloc>.value(
          value: polynomialBloc,
          child: const PolynomialResults(),
        ),
      ));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('No solutions to display.'), findsNothing);
      expect(find.byType(ComplexResultCard), findsNWidgets(2));
      expect(find.byKey(const Key('PolynomialDiscriminant')), findsOneWidget);
    });

    testWidgets(
        'Making sure that when an error occurred while solving the '
        'equation, a Snackbar appears.', (tester) async {
      when(() => polynomialBloc.state).thenReturn(const PolynomialNone());

      // Triggering the consumer to listen for the error state
      whenListen<PolynomialState>(
        polynomialBloc,
        Stream<PolynomialState>.fromIterable(const [
          PolynomialNone(),
          PolynomialError(),
        ]),
      );

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<PolynomialBloc>.value(
          value: polynomialBloc,
          child: const PolynomialResults(),
        ),
      ));

      // Refreshing to make the snackbar appear
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testGoldens('PolynomialResults', (tester) async {
      final linear = Algebraic.fromReal(const [1, 2]);

      when(() => polynomialBloc.state).thenReturn(PolynomialRoots(
        algebraic: linear,
        roots: linear.solutions(),
        discriminant: linear.discriminant(),
      ));

      final widget = BlocProvider<PolynomialBloc>.value(
        value: polynomialBloc,
        child: const PolynomialResults(),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(400, 700),
      );
      await screenMatchesGolden(tester, 'polynomial_results');
    });
  });
}
