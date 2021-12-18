import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'IntegralBloc' bloc", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = IntegralBloc();

      expect(bloc.state, equals(const IntegralNone()));
    });

    blocTest<IntegralBloc, IntegralState>(
      'Making sure that the bloc can be cleared',
      build: () => IntegralBloc(),
      act: (bloc) => bloc.add(const IntegralClean()),
      expect: () => const [
        IntegralNone(),
      ],
    );

    blocTest<IntegralBloc, IntegralState>(
      'Making sure that the bloc can integrate using the Simpson rule',
      build: () => IntegralBloc(),
      act: (bloc) => bloc.add(const IntegralSolve(
        function: 'x+2',
        lowerBound: '-2',
        upperBound: '7',
        integralType: IntegralType.simpson,
        intervals: 32,
      )),
      expect: () => const [
        IntegralResult(
          result: 40.5,
          numericalIntegration: SimpsonRule(
            function: 'x+2',
            lowerBound: -2,
            upperBound: 7,
          ),
        ),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<IntegralResult>());
        expect(
          (bloc.state as IntegralResult).numericalIntegration,
          isA<SimpsonRule>(),
        );
      },
    );

    blocTest<IntegralBloc, IntegralState>(
      'Making sure that the bloc can integrate using the trapezoid rule',
      build: () => IntegralBloc(),
      act: (bloc) => bloc.add(const IntegralSolve(
        function: 'x+2',
        lowerBound: '-2',
        upperBound: '7',
        integralType: IntegralType.trapezoid,
        intervals: 32,
      )),
      expect: () => const [
        IntegralResult(
          result: 40.5,
          numericalIntegration: TrapezoidalRule(
            function: 'x+2',
            lowerBound: -2,
            upperBound: 7,
            intervals: 32,
          ),
        ),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<IntegralResult>());
        expect(
          (bloc.state as IntegralResult).numericalIntegration,
          isA<TrapezoidalRule>(),
        );
      },
    );

    blocTest<IntegralBloc, IntegralState>(
      'Making sure that the bloc can integrate using the midpoint rule',
      build: () => IntegralBloc(),
      act: (bloc) => bloc.add(const IntegralSolve(
        function: 'x+2',
        lowerBound: '-2',
        upperBound: '7',
        integralType: IntegralType.midPoint,
        intervals: 32,
      )),
      expect: () => const [
        IntegralResult(
          result: 40.5,
          numericalIntegration: MidpointRule(
            function: 'x+2',
            lowerBound: -2,
            upperBound: 7,
            intervals: 32,
          ),
        ),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<IntegralResult>());
        expect(
          (bloc.state as IntegralResult).numericalIntegration,
          isA<MidpointRule>(),
        );
      },
    );

    blocTest<IntegralBloc, IntegralState>(
      'Making sure that an exception is thrown in case of invalid function',
      build: () => IntegralBloc(),
      act: (bloc) => bloc.add(const IntegralSolve(
        function: 'x+2x',
        lowerBound: '-2',
        upperBound: '7',
        integralType: IntegralType.simpson,
        intervals: 32,
      )),
      expect: () => const [
        IntegralError(),
      ],
    );

    blocTest<IntegralBloc, IntegralState>(
      'Making sure that an exception is thrown in case of invalid values',
      build: () => IntegralBloc(),
      act: (bloc) => bloc.add(const IntegralSolve(
        function: 'x+2',
        lowerBound: '',
        upperBound: '7',
        integralType: IntegralType.simpson,
        intervals: 32,
      )),
      expect: () => const [
        IntegralError(),
      ],
    );
  });
}
