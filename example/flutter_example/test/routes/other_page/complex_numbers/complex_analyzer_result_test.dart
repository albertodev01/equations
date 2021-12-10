import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_analyzer_results.dart';
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

  setUpAll(() {
    registerFallbackValue(MockOtherEvent());
    registerFallbackValue(MockOtherState());

    bloc = MockOtherBloc();
  });

  group("Testing the 'ComplexNumberAnalyzerResult' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<OtherBloc>(
          create: (_) => OtherBloc(),
          child: const ComplexNumberAnalyzerResult(),
        ),
      ));

      expect(find.byType(ComplexNumberAnalyzerResult), findsOneWidget);
      expect(find.byType(RealResultCard), findsNothing);
    });

    testWidgets(
      'Making sure that a progress indicator appears while loading data',
      (tester) async {
        when(() => bloc.state).thenReturn(const OtherLoading());

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<OtherBloc>.value(
            value: bloc,
            child: const ComplexNumberAnalyzerResult(),
          ),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(RealResultCard), findsNothing);
      },
    );

    testWidgets(
      'Making sure that analysis results can correctly be displayed',
      (tester) async {
        when(() => bloc.state).thenReturn(const AnalyzedComplexNumber(
          abs: 1,
          phase: 1,
          conjugate: Complex.zero(),
          reciprocal: Complex.zero(),
          sqrt: Complex.zero(),
          polarComplex: PolarComplex(r: 1, phiRadians: 1, phiDegrees: 1),
        ));

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<OtherBloc>.value(
            value: bloc,
            child: const SingleChildScrollView(
              child: ComplexNumberAnalyzerResult(),
            ),
          ),
        ));

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(5));
        expect(find.byType(ComplexResultCard), findsNWidgets(3));
      },
    );

    testGoldens('ComplexNumberAnalyzerResult', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'No results',
          Builder(builder: (context) {
            when(() => bloc.state).thenReturn(const OtherNone());

            return BlocProvider<OtherBloc>.value(
              value: bloc,
              child: const ComplexNumberAnalyzerResult(),
            );
          }),
        )
        ..addScenario(
          'Results',
          Builder(builder: (context) {
            when(() => bloc.state).thenReturn(const AnalyzedComplexNumber(
              abs: 1,
              phase: 1,
              conjugate: Complex.zero(),
              reciprocal: Complex.zero(),
              sqrt: Complex.zero(),
              polarComplex: PolarComplex(r: 1, phiRadians: 1, phiDegrees: 1),
            ));

            return BlocProvider<OtherBloc>.value(
              value: bloc,
              child: const ComplexNumberAnalyzerResult(),
            );
          }),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(500, 1500),
      );
      await screenMatchesGolden(tester, 'complex_analyze_results');
    });
  });
}
