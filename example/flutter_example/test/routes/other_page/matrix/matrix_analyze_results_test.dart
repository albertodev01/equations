import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyze_results.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_output.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/bloc_mocks.dart';
import '../../mock_wrapper.dart';

void main() {
  late final OtherBloc bloc;
  late final AnalyzedMatrix mockResult;

  setUpAll(() {
    registerFallbackValue(MockOtherEvent());
    registerFallbackValue(MockOtherState());

    bloc = MockOtherBloc();

    mockResult = AnalyzedMatrix(
      eigenvalues: const [
        Complex.fromReal(5.37288),
        Complex.fromReal(-0.372281),
      ],
      rank: 2,
      determinant: -2,
      trace: 5,
      inverse: RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          -2,
          1,
          1.5,
          -0.5,
        ],
      ),
      cofactorMatrix: RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          4,
          -3,
          -2,
          1,
        ],
      ),
      transpose: RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          1,
          3,
          2,
          4,
        ],
      ),
      characteristicPolynomial: Algebraic.fromReal([1, -5, -2]),
      isIdentity: true,
      isDiagonal: true,
      isSymmetric: false,
    );
  });

  group("Testing the 'MatrixOtherBody' widget", () {
    testWidgets(
      'Making sure that the widget renders nothing when there are no '
      'analysis results',
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 1, max: 5),
              ),
              BlocProvider<OtherBloc>(
                create: (_) => OtherBloc(),
              ),
            ],
            child: const MatrixAnalyzerResults(),
          ),
        ));

        expect(find.byType(RealResultCard), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
      'Making sure that the widget is responsive - small screens test',
      (tester) async {
        when(() => bloc.state).thenReturn(mockResult);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 1, max: 5),
              ),
              BlocProvider<OtherBloc>.value(
                value: bloc,
              ),
            ],
            child: const SingleChildScrollView(
              child: MatrixAnalyzerResults(),
            ),
          ),
        ));

        expect(
          find.byType(Wrap),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that the widget is responsive - large screens test',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 2000));

        when(() => bloc.state).thenReturn(mockResult);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 1, max: 5),
              ),
              BlocProvider<OtherBloc>.value(
                value: bloc,
              ),
            ],
            child: const SingleChildScrollView(
              child: MatrixAnalyzerResults(),
            ),
          ),
        ));

        expect(
          find.byType(Wrap),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Making sure that a progress indicator appears while results are loading',
      (tester) async {
        when(() => bloc.state).thenReturn(const OtherLoading());

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 1, max: 5),
              ),
              BlocProvider<OtherBloc>.value(
                value: bloc,
              ),
            ],
            child: const MatrixAnalyzerResults(),
          ),
        ));

        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(RealResultCard), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the widget correctly shows the results',
      (tester) async {
        when(() => bloc.state).thenReturn(mockResult);

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 1, max: 5),
              ),
              BlocProvider<OtherBloc>.value(
                value: bloc,
              ),
            ],
            child: const SingleChildScrollView(
              child: MatrixAnalyzerResults(),
            ),
          ),
        ));

        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(3));
        expect(find.byType(ComplexResultCard), findsNWidgets(2));
        expect(find.byType(MatrixOutput), findsNWidgets(3));
      },
    );

    testGoldens('MatrixAnalyzerResults', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'No results',
          Builder(builder: (context) {
            when(() => bloc.state).thenReturn(const OtherNone());

            return BlocProvider<OtherBloc>.value(
              value: bloc,
              child: const MatrixAnalyzerResults(),
            );
          }),
        )
        ..addScenario(
          'Results',
          Builder(builder: (context) {
            when(() => bloc.state).thenReturn(mockResult);

            return BlocProvider<OtherBloc>.value(
              value: bloc,
              child: const MatrixAnalyzerResults(),
            );
          }),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(500, 2400),
      );
      await screenMatchesGolden(tester, 'matrix_analyze_results');
    });
  });
}
