import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart' as equations;
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/nonlinear_page/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final MockNonlinearBloc nonlinearBloc;

  setUpAll(() {
    registerFallbackValue<NonlinearEvent>(MockNonlinearEvent());
    registerFallbackValue<NonlinearState>(MockNonlinearState());

    nonlinearBloc = MockNonlinearBloc();
  });

  group("Testing the 'NonlinearResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NonlinearBloc>(
          create: (_) => NonlinearBloc(NonlinearType.singlePoint),
          child: const NonlinearResults(),
        ),
      ));

      expect(find.byType(NonlinearResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
    });

    testWidgets(
      'Making sure that when an error occurred while solving the equation, '
      'a Snackbar appears.',
      (tester) async {
        when(() => nonlinearBloc.state).thenReturn(const NonlinearError());

        // Triggering the consumer to listen for the error state
        whenListen<NonlinearState>(
          nonlinearBloc,
          Stream<NonlinearState>.fromIterable(const [
            NonlinearNone(),
            NonlinearError(),
          ]),
        );

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<NonlinearBloc>.value(
            value: nonlinearBloc,
            child: const NonlinearResults(),
          ),
        ));

        // Refreshing to make the snackbar appear
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that, when there are no solutions, a text widget '
      "appears saying that there's nothing to display",
      (tester) async {
        when(() => nonlinearBloc.state).thenReturn(const NonlinearNone());

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<NonlinearBloc>.value(
            value: nonlinearBloc,
            child: const NonlinearResults(),
          ),
        ));

        expect(find.byType(ListView), findsNothing);
        expect(find.text('No solutions to display.'), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that, when there are solutions, solution widgets '
      'appear on the screen',
      (tester) async {
        const newton = equations.Newton(function: 'x-2', x0: 2);

        when(() => nonlinearBloc.state).thenReturn(NonlinearGuesses(
          nonLinear: newton,
          nonlinearResults: newton.solve(),
        ));

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<NonlinearBloc>.value(
            value: nonlinearBloc,
            child: const NonlinearResults(),
          ),
        ));

        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('No solutions to display.'), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(3));
      },
    );

    testGoldens('PolynomialResults', (tester) async {
      const newton = equations.Newton(function: 'x-2', x0: 2);

      when(() => nonlinearBloc.state).thenReturn(NonlinearGuesses(
        nonLinear: newton,
        nonlinearResults: newton.solve(),
      ));

      final widget = BlocProvider<NonlinearBloc>.value(
        value: nonlinearBloc,
        child: const NonlinearResults(),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(400, 700),
      );
      await screenMatchesGolden(tester, 'nonlinear_results');
    });
  });
}
