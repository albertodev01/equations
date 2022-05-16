import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the 'OtherBloc' bloc", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = OtherBloc();

      expect(bloc.state, equals(const OtherNone()));
    });

    blocTest<OtherBloc, OtherState>(
      'Making sure that the bloc emits states',
      build: OtherBloc.new,
      act: (bloc) => bloc.add(const OtherClean()),
      expect: () => const [OtherNone()],
      verify: (bloc) => bloc.state == const OtherNone(),
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that an exception is thrown if one (or more) matrix input '
      'values are malformed strings',
      build: OtherBloc.new,
      act: (bloc) => bloc.add(
        const MatrixAnalyze(
          size: 2,
          matrix: ['1', '2', '3', 'c'],
        ),
      ),
      expect: () => const [
        OtherLoading(),
        OtherError(),
      ],
      verify: (bloc) => bloc.state == const OtherError(),
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that an exception is thrown if the matrix size does NOT '
      'match the actual list length',
      build: OtherBloc.new,
      act: (bloc) => bloc.add(
        const MatrixAnalyze(
          size: 3,
          matrix: ['1', '2', '3', '4'],
        ),
      ),
      expect: () => const [
        OtherLoading(),
        OtherError(),
      ],
      verify: (bloc) => bloc.state == const OtherError(),
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that an exception is thrown if the complex number has a '
      'malformed real input',
      build: OtherBloc.new,
      act: (bloc) => bloc.add(
        const ComplexNumberAnalyze(
          realPart: '',
          imaginaryPart: '1',
        ),
      ),
      expect: () => const [
        OtherLoading(),
        OtherError(),
      ],
      verify: (bloc) => bloc.state == const OtherError(),
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that an exception is thrown if the complex number has a '
      'malformed complex input',
      build: OtherBloc.new,
      act: (bloc) => bloc.add(
        const ComplexNumberAnalyze(
          realPart: '2',
          imaginaryPart: '...',
        ),
      ),
      expect: () => const [
        OtherLoading(),
        OtherError(),
      ],
      verify: (bloc) => bloc.state == const OtherError(),
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that matrices can be analyzed',
      build: OtherBloc.new,
      act: (bloc) => bloc.add(
        const MatrixAnalyze(
          size: 2,
          matrix: ['1', '2', '3', '5'],
        ),
      ),
      verify: (bloc) {
        expect(bloc.state, isA<AnalyzedMatrix>());

        final state = bloc.state as AnalyzedMatrix;

        expect(state.trace, equals(6));
        expect(state.rank, equals(2));
        expect(state.determinant, equals(-1));
        expect(
          state.characteristicPolynomial,
          equals(
            Algebraic.fromReal(
              [1, -6, -1],
            ),
          ),
        );
        expect(
          state.inverse,
          equals(
            RealMatrix.fromData(
              rows: 2,
              columns: 2,
              data: [
                [-5, 2],
                [3, -1],
              ],
            ),
          ),
        );
        expect(
          state.transpose,
          equals(
            RealMatrix.fromData(
              rows: 2,
              columns: 2,
              data: [
                [1, 3],
                [2, 5],
              ],
            ),
          ),
        );

        expect(
          state.transpose,
          equals(
            RealMatrix.fromData(
              rows: 2,
              columns: 2,
              data: [
                [1, 3],
                [2, 5],
              ],
            ),
          ),
        );
      },
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that complex numbers can be analyzed',
      build: OtherBloc.new,
      act: (bloc) => bloc.add(
        const ComplexNumberAnalyze(
          realPart: '3',
          imaginaryPart: '2',
        ),
      ),
      verify: (bloc) {
        expect(bloc.state, isA<AnalyzedComplexNumber>());

        final state = bloc.state as AnalyzedComplexNumber;

        expect(
          state.phase,
          const MoreOrLessEquals(0.588, precision: 1.0e-4),
        );
        expect(
          state.sqrt.real,
          const MoreOrLessEquals(1.8173, precision: 1.0e-4),
        );
        expect(
          state.sqrt.imaginary,
          const MoreOrLessEquals(0.5502, precision: 1.0e-4),
        );
        expect(
          state.reciprocal.real,
          const MoreOrLessEquals(0.2307, precision: 1.0e-4),
        );
        expect(
          state.reciprocal.imaginary,
          const MoreOrLessEquals(-0.1538, precision: 1.0e-4),
        );
        expect(
          state.polarComplex.r,
          const MoreOrLessEquals(3.6055, precision: 1.0e-4),
        );
        expect(
          state.polarComplex.phiDegrees,
          const MoreOrLessEquals(33.69, precision: 1.0e-4),
        );
        expect(
          state.polarComplex.phiRadians,
          const MoreOrLessEquals(0.588, precision: 1.0e-4),
        );
        expect(state.abs, const MoreOrLessEquals(3.6055, precision: 1.0e-4));
        expect(state.conjugate, equals(const Complex(3, -2)));
      },
    );
  });
}
