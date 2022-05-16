import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyzer_input.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/bloc_mocks.dart';
import '../../mock_wrapper.dart';

void main() {
  late final OtherBloc bloc;
  late final AnalyzedMatrix analyzedMatrix;

  setUpAll(() {
    registerFallbackValue(MockOtherEvent());
    registerFallbackValue(MockOtherState());

    bloc = MockOtherBloc();

    analyzedMatrix = AnalyzedMatrix(
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

  group("Testing the 'MatrixAnalyzerInput' widget", () {
    testWidgets(
      'Making sure that when trying to evaluate a matrix, if at least one of '
      'the inputs is wrong, a snackbar appears',
      (tester) async {
        when(() => bloc.state).thenReturn(const OtherNone());

        await tester.pumpWidget(
          MockWrapper(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<NumberSwitcherCubit>(
                  create: (_) => NumberSwitcherCubit(min: 1, max: 5),
                ),
                BlocProvider<OtherBloc>.value(
                  value: bloc,
                ),
              ],
              child: const MatrixAnalyzerInput(),
            ),
          ),
        );

        expect(find.byType(SizePicker), findsOneWidget);
        expect(find.byType(MatrixInput), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);

        // Entering some text
        await tester.enterText(find.byType(TextFormField), 'abc');
        await tester.tap(find.byKey(const Key('MatrixAnalyze-button-analyze')));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the form can be cleared correctly',
      (tester) async {
        late FocusScopeNode focusScope;
        when(() => bloc.state).thenReturn(const OtherNone());

        await tester.pumpWidget(
          MockWrapper(
            child: MultiBlocProvider(
              providers: [
                BlocProvider<NumberSwitcherCubit>(
                  create: (_) => NumberSwitcherCubit(min: 1, max: 5),
                ),
                BlocProvider<OtherBloc>.value(
                  value: bloc,
                ),
              ],
              child: Builder(
                builder: (context) {
                  focusScope = FocusScope.of(context);

                  return const MatrixAnalyzerInput();
                },
              ),
            ),
          ),
        );

        expect(find.byType(SizePicker), findsOneWidget);
        expect(find.byType(MatrixInput), findsOneWidget);

        when(() => bloc.state).thenReturn(analyzedMatrix);

        // Entering some text
        await tester.enterText(find.byType(TextFormField), '435');
        await tester.tap(find.byKey(const Key('MatrixAnalyze-button-analyze')));
        expect(focusScope.hasFocus, isTrue);

        // Now clearing
        expect(find.text('435'), findsOneWidget);

        await tester.tap(find.byKey(const Key('MatrixAnalyze-button-clean')));
        await tester.pumpAndSettle();

        expect(find.text('435'), findsNothing);
        expect(focusScope.hasFocus, isFalse);

        tester
            .widgetList<TextFormField>(find.byType(TextFormField))
            .forEach((t) {
          expect(t.controller!.text.length, isZero);
        });
      },
    );

    testGoldens('MatrixAnalyzerInput', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          '1x1',
          MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 1, max: 5),
              ),
              BlocProvider<OtherBloc>(
                create: (_) => OtherBloc(),
              ),
            ],
            child: const MatrixAnalyzerInput(),
          ),
        )
        ..addScenario(
          '2x2',
          MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 2, max: 5),
              ),
              BlocProvider<OtherBloc>(
                create: (_) => OtherBloc(),
              ),
            ],
            child: const MatrixAnalyzerInput(),
          ),
        )
        ..addScenario(
          '3x3',
          MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 3, max: 5),
              ),
              BlocProvider<OtherBloc>(
                create: (_) => OtherBloc(),
              ),
            ],
            child: const MatrixAnalyzerInput(),
          ),
        )
        ..addScenario(
          '4x4',
          MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 4, max: 5),
              ),
              BlocProvider<OtherBloc>(
                create: (_) => OtherBloc(),
              ),
            ],
            child: const MatrixAnalyzerInput(),
          ),
        )
        ..addScenario(
          '5x5',
          MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 5, max: 6),
              ),
              BlocProvider<OtherBloc>(
                create: (_) => OtherBloc(),
              ),
            ],
            child: const MatrixAnalyzerInput(),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(700, 2300),
      );
      await screenMatchesGolden(tester, 'matrix_analyze_input');
    });
  });
}
