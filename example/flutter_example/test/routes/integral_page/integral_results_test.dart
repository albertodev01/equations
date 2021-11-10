import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final IntegralBloc integralBloc;

  setUpAll(() {
    registerFallbackValue(MockIntegralEvent());
    registerFallbackValue(MockIntegralState());

    integralBloc = MockIntegralBloc();
  });

  group("Testing the 'IntegralResults' widget", () {
    testWidgets(
      'Making sure that, by default, the "No results" text appears',
      (tester) async {
        when(() => integralBloc.state).thenReturn(const IntegralNone());

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<IntegralBloc>.value(
            value: integralBloc,
            child: const Scaffold(
              body: IntegralResultsWidget(),
            ),
          ),
        ));

        // No snackbar by default
        expect(find.byType(NoResults), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that a result card appears when there is a solution to show',
      (tester) async {
        when(() => integralBloc.state).thenReturn(const IntegralResult(
          result: 1 / 2,
          numericalIntegration: SimpsonRule(
            function: 'x-1',
            lowerBound: 1,
            upperBound: 2,
          ),
        ));

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<IntegralBloc>.value(
            value: integralBloc,
            child: const Scaffold(
              body: IntegralResultsWidget(),
            ),
          ),
        ));

        // No snackbar by default
        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that a snackbar appears in case of computation errors',
      (tester) async {
        whenListen(
          integralBloc,
          Stream<IntegralState>.fromIterable(
            const [
              IntegralNone(),
              IntegralError(),
            ],
          ),
        );

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<IntegralBloc>.value(
            value: integralBloc,
            child: const Scaffold(
              body: IntegralResultsWidget(),
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // No snackbar by default
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testGoldens('IntegralDataInput - Midpoint', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'No results',
          Builder(builder: (context) {
            when(() => integralBloc.state).thenReturn(const IntegralNone());

            return BlocProvider<IntegralBloc>.value(
              value: integralBloc,
              child: const IntegralResultsWidget(),
            );
          }),
        )
        ..addScenario(
          'With results',
          Builder(builder: (context) {
            when(() => integralBloc.state).thenReturn(const IntegralResult(
              result: 1 / 2,
              numericalIntegration: SimpsonRule(
                function: 'x-1',
                lowerBound: 1,
                upperBound: 2,
              ),
            ));

            return BlocProvider<IntegralBloc>.value(
              value: integralBloc,
              child: const IntegralResultsWidget(),
            );
          }),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(600, 600),
      );
      await screenMatchesGolden(tester, 'integral_results_widget');
    });
  });
}
