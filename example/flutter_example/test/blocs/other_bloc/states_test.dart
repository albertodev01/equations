import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing events for the 'OtherBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      final matrix = AnalyzedMatrix(
        determinant: 1,
        eigenvalues: const [Complex.fromReal(1)],
        characteristicPolynomial: Algebraic.fromReal([2]),
        rank: 1,
        trace: 1,
        transpose: RealMatrix.diagonal(
          rows: 1,
          columns: 1,
          diagonalValue: 0,
        ),
        cofactorMatrix: RealMatrix.diagonal(
          rows: 1,
          columns: 1,
          diagonalValue: 0,
        ),
        inverse: RealMatrix.diagonal(
          rows: 1,
          columns: 1,
          diagonalValue: 0,
        ),
        isIdentity: true,
        isDiagonal: true,
        isSymmetric: false,
      );

      const complex = AnalyzedComplexNumber(
        polarComplex: PolarComplex(r: 1, phiRadians: 1, phiDegrees: 1),
        sqrt: Complex.fromReal(1),
        reciprocal: Complex.fromReal(2),
        conjugate: Complex.fromReal(3),
        phase: 1,
        abs: 2,
      );

      expect(
        matrix,
        equals(AnalyzedMatrix(
          determinant: 1,
          eigenvalues: const [Complex.fromReal(1)],
          characteristicPolynomial: Algebraic.fromReal([2]),
          rank: 1,
          trace: 1,
          transpose: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          cofactorMatrix: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          inverse: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          isIdentity: true,
          isDiagonal: true,
          isSymmetric: false,
        )),
      );

      expect(
        matrix,
        isNot(AnalyzedMatrix(
          determinant: 2,
          eigenvalues: const [Complex.fromReal(1)],
          characteristicPolynomial: Algebraic.fromReal([2]),
          rank: 1,
          trace: 1,
          transpose: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          cofactorMatrix: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          inverse: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          isIdentity: true,
          isDiagonal: true,
          isSymmetric: false,
        )),
      );

      expect(
        matrix,
        isNot(AnalyzedMatrix(
          determinant: 1,
          eigenvalues: const [Complex.fromReal(2)],
          characteristicPolynomial: Algebraic.fromReal([2]),
          rank: 1,
          trace: 1,
          transpose: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          cofactorMatrix: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          inverse: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          isIdentity: true,
          isDiagonal: true,
          isSymmetric: false,
        )),
      );

      expect(
        matrix,
        isNot(AnalyzedMatrix(
          determinant: 2,
          eigenvalues: const [Complex.fromReal(1)],
          characteristicPolynomial: Algebraic.fromReal([1]),
          rank: 1,
          trace: 1,
          transpose: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          cofactorMatrix: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          inverse: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          isIdentity: true,
          isDiagonal: true,
          isSymmetric: false,
        )),
      );

      expect(
        matrix,
        isNot(AnalyzedMatrix(
          determinant: 2,
          eigenvalues: const [Complex.fromReal(1)],
          characteristicPolynomial: Algebraic.fromReal([2]),
          rank: 1,
          trace: 1,
          transpose: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          cofactorMatrix: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 1,
          ),
          inverse: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          isIdentity: true,
          isDiagonal: true,
          isSymmetric: false,
        )),
      );

      expect(
        matrix,
        isNot(AnalyzedMatrix(
          determinant: 1,
          eigenvalues: const [Complex.fromReal(1)],
          characteristicPolynomial: Algebraic.fromReal([2]),
          rank: 1,
          trace: 1,
          transpose: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          cofactorMatrix: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          inverse: RealMatrix.diagonal(
            rows: 1,
            columns: 1,
            diagonalValue: 0,
          ),
          isIdentity: true,
          isDiagonal: false,
          isSymmetric: false,
        )),
      );

      expect(
        complex,
        equals(const AnalyzedComplexNumber(
          polarComplex: PolarComplex(r: 1, phiRadians: 1, phiDegrees: 1),
          sqrt: Complex.fromReal(1),
          reciprocal: Complex.fromReal(2),
          conjugate: Complex.fromReal(3),
          phase: 1,
          abs: 2,
        )),
      );

      expect(
        complex,
        isNot(const AnalyzedComplexNumber(
          polarComplex: PolarComplex(r: 1, phiRadians: 1, phiDegrees: 1),
          sqrt: Complex.fromReal(1),
          reciprocal: Complex.fromReal(1),
          conjugate: Complex.fromReal(3),
          phase: 1,
          abs: 2,
        )),
      );

      expect(
        complex,
        isNot(const AnalyzedComplexNumber(
          polarComplex: PolarComplex(r: 1, phiRadians: 2, phiDegrees: 1),
          sqrt: Complex.fromReal(1),
          reciprocal: Complex.fromReal(2),
          conjugate: Complex.fromReal(3),
          phase: 1,
          abs: 2,
        )),
      );

      expect(
        const OtherLoading(),
        equals(const OtherLoading()),
      );

      expect(
        const OtherError(),
        equals(const OtherError()),
      );

      expect(
        const OtherNone(),
        equals(const OtherNone()),
      );

      expect(matrix.props.length, equals(11));
      expect(complex.props.length, equals(6));
      expect(const OtherClean().props.length, isZero);
      expect(const OtherClean().props.length, isZero);
      expect(const OtherError().props.length, isZero);
      expect(const OtherNone().props.length, isZero);
    });
  });
}
