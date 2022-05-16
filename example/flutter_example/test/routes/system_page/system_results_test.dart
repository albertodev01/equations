import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/routes/system_page/system_results.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  late final SystemBloc systemBloc;

  setUpAll(() {
    registerFallbackValue(MockSystemEvent());
    registerFallbackValue(MockSystemState());

    systemBloc = MockSystemBloc();
  });

  group("Testing the 'PolynomialResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: BlocProvider<SystemBloc>(
            create: (_) => SystemBloc(SystemType.rowReduction),
            child: const SystemResults(),
          ),
        ),
      );

      expect(find.byType(SystemResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
    });

    testWidgets(
      'Making sure that in case of error, nothing appears on the '
      'screen',
      (tester) async {
        when(() => systemBloc.state).thenReturn(const SystemError());

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<SystemBloc>.value(
              value: systemBloc,
              child: const SystemResults(),
            ),
          ),
        );

        expect(find.byType(ListView), findsNothing);
        expect(find.byType(NoResults), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that in case of singular system error, nothing '
      'appears on the screen',
      (tester) async {
        when(() => systemBloc.state).thenReturn(const SingularSystemError());

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<SystemBloc>.value(
              value: systemBloc,
              child: const SystemResults(),
            ),
          ),
        );

        expect(find.byType(ListView), findsNothing);
        expect(find.byType(NoResults), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that, when there are solutions, solution widgets '
      'appear on the screen',
      (tester) async {
        final solver = LUSolver(
          matrix: RealMatrix.fromFlattenedData(
            rows: 2,
            columns: 2,
            data: [1, 2, 3, 4],
          ),
          knownValues: [-3, 5],
        );

        when(() => systemBloc.state).thenReturn(
          SystemGuesses(
            solution: solver.solve(),
            systemSolver: solver,
          ),
        );

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<SystemBloc>.value(
              value: systemBloc,
              child: const SystemResults(),
            ),
          ),
        );

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(2));
      },
    );

    testWidgets(
      'Making sure that when an error occurred while solving the '
      'system, a Snackbar appears.',
      (tester) async {
        when(() => systemBloc.state).thenReturn(const SystemNone());

        // Triggering the consumer to listen for the error state
        whenListen<SystemState>(
          systemBloc,
          Stream<SystemState>.fromIterable(const [
            SystemNone(),
            SystemError(),
          ]),
        );

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<SystemBloc>.value(
              value: systemBloc,
              child: const SystemResults(),
            ),
          ),
        );

        // Refreshing to make the Snackbar appear
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that when an error occurred (because the matrix '
      'is singular), a Snackbar appears.',
      (tester) async {
        when(() => systemBloc.state).thenReturn(const SystemNone());

        // Triggering the consumer to listen for the error state
        whenListen<SystemState>(
          systemBloc,
          Stream<SystemState>.fromIterable(const [
            SystemNone(),
            SingularSystemError(),
          ]),
        );

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<SystemBloc>.value(
              value: systemBloc,
              child: const SystemResults(),
            ),
          ),
        );

        // Refreshing to make the Snackbar appear
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testGoldens('SystemResults', (tester) async {
      final solver = LUSolver(
        matrix: RealMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: [1, 2, 3, 4],
        ),
        knownValues: [-3, 5],
      );

      when(() => systemBloc.state).thenReturn(
        SystemGuesses(
          solution: solver.solve(),
          systemSolver: solver,
        ),
      );

      final widget = BlocProvider<SystemBloc>.value(
        value: systemBloc,
        child: const SystemResults(),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(400, 500),
      );
      await screenMatchesGolden(tester, 'system_results');
    });
  });
}
