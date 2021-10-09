import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'OtherBloc' bloc", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = OtherBloc();

      expect(bloc.state, equals(const OtherNone()));
    });

    blocTest<OtherBloc, OtherState>(
      'Making sure that the bloc emits states',
      build: () => OtherBloc(),
      act: (bloc) => bloc.add(const OtherClean()),
      expect: () => const [OtherNone()],
      verify: (bloc) => bloc.state == const OtherNone(),
    );

    /*blocTest<OtherBloc, OtherState>(
      'Making sure that an exception is thrown if one (or more) matrix input '
      'values are malformed strings',
      build: () => OtherBloc(),
      act: (bloc) => bloc.add(const MatrixAnalyze(
        size: 2,
        matrix: ['1', '2', '3', 'c'],
      )),
      expect: () => const [
        OtherLoading(),
        OtherError(),
      ],
      verify: (bloc) => bloc.state == const OtherError(),
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that an exception is thrown if the matrix size does NOT '
      'match the actual list length',
      build: () => OtherBloc(),
      act: (bloc) => bloc.add(const MatrixAnalyze(
        size: 3,
        matrix: ['1', '2', '3', '4'],
      )),
      expect: () => const [
        OtherLoading(),
        OtherError(),
      ],
      verify: (bloc) => bloc.state == const OtherError(),
    );

    blocTest<OtherBloc, OtherState>(
      'Making sure that an exception is thrown if the matrix size does NOT '
      'match the actual list length',
      build: () => OtherBloc(),
      act: (bloc) => bloc.add(const MatrixAnalyze(
        size: 2,
        matrix: ['1', '2', '3', '5'],
      )),
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
                [5, -3],
                [-2, 1],
              ],
            ),
          ),
        );
      },
    );*/
  });
}
