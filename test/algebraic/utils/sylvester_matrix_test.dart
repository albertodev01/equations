import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('Testing the behaviors of the SylvesterMatrix class.', () {
    final matrix = SylvesterMatrix.fromReal(coefficients: [1, -7, 8]);

    test('Making sure that SylvesterMatrix values are properly constructed.',
        () {
      expect(
        matrix.coefficients,
        orderedEquals(
          const <Complex>[
            Complex.fromReal(1),
            Complex.fromReal(-7),
            Complex.fromReal(8),
          ],
        ),
      );
    });

    test('Making sure that the list of coefficients is unmodifiable.', () {
      expect(
        () => matrix.coefficients[0] = const Complex.zero(),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('Making sure that the discriminant is properly computed.', () {
      expect(matrix.polynomialDiscriminant(), equals(const Complex(17, 0)));
      expect(
        matrix.polynomialDiscriminant(optimize: false),
        equals(const Complex(17, 0)),
      );
    });

    test('Making sure that the determinant is properly computed.', () {
      expect(
        matrix.matrixDeterminant(),
        equals(-const Complex(17, 0)),
      );
    });

    test('Making sure that SylvesterMatrix instances can be properly compared.',
        () {
      final matrix2 = SylvesterMatrix(
        coefficients: const [
          Complex.fromReal(1),
          Complex.fromReal(-7),
          Complex.fromReal(8),
        ],
      );

      expect(matrix == matrix2, isTrue);
      expect(matrix.hashCode, equals(matrix2.hashCode));
    });
  });
}
