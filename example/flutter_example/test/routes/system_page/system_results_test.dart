import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/routes/system_page/system_results.dart';
import 'package:equations_solver/routes/system_page/utils/double_result_card.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
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
    registerFallbackValue<SystemEvent>(MockSystemEvent());
    registerFallbackValue<SystemState>(MockSystemState());

    systemBloc = MockSystemBloc();
  });

  group("Testing the 'PolynomialResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<SystemBloc>(
          create: (_) => SystemBloc(SystemType.rowReduction),
          child: const SystemResults(),
        ),
      ));

      expect(find.byType(SystemResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
    });

    testWidgets(
        'Making sure that in case of error, nothing appears on the '
        'screen', (tester) async {
      when(() => systemBloc.state).thenReturn(const SystemError());

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<SystemBloc>.value(
          value: systemBloc,
          child: const SystemResults(),
        ),
      ));

      expect(find.byType(ListView), findsNothing);
      expect(find.byType(NoResults), findsOneWidget);
    });

    testWidgets(
        'Making sure that in case of singular system error, nothing '
        'appears on the screen', (tester) async {
      when(() => systemBloc.state).thenReturn(const SingularSystemError());

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<SystemBloc>.value(
          value: systemBloc,
          child: const SystemResults(),
        ),
      ));

      expect(find.byType(ListView), findsNothing);
      expect(find.byType(NoResults), findsOneWidget);
    });

    testWidgets(
        'Making sure that, when there are solutions, solution widgets '
        'appear on the screen', (tester) async {
      final solver = LUSolver.flatMatrix(
        equations: [1, 2, 3, 4],
        constants: [-3, 5],
      );

      when(() => systemBloc.state).thenReturn(SystemGuesses(
        solution: solver.solve(),
        systemSolver: solver,
      ));

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<SystemBloc>.value(
          value: systemBloc,
          child: const SystemResults(),
        ),
      ));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(NoResults), findsNothing);
      expect(find.byType(DoubleResultCard), findsNWidgets(2));
    });

    testGoldens('SystemResults', (tester) async {
      final solver = LUSolver.flatMatrix(
        equations: [1, 2, 3, 4],
        constants: [-3, 5],
      );

      when(() => systemBloc.state).thenReturn(SystemGuesses(
        solution: solver.solve(),
        systemSolver: solver,
      ));

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
