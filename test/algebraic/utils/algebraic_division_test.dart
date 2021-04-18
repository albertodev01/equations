import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('Testing the behaviors of the AlgebraicDivision class.', () {
    final results = AlgebraicDivision(
      remainder: Algebraic.fromReal([1, -3, 6, 7.8]),
      quotient: Algebraic.fromReal([2, -9]),
    );

    test('Making sure that values are properly constructed.', () {
      expect(
        results.remainder,
        equals(Algebraic.fromReal([1, -3, 6, 7.8])),
      );
      expect(
        results.quotient,
        equals(Algebraic.fromReal([2, -9])),
      );
    });

    test("Making sure that 'toString()' is properly overridden", () {
      final results = AlgebraicDivision(
        remainder: Algebraic.fromReal([1, 2, 3]),
        quotient: Algebraic.fromReal([2, 1]),
      );

      expect(results.toString(), equals('Q = 2x + 1\nR = 1x^2 + 2x + 3'));
    });

    test('Making sure that instances can be properly compared.', () {
      final results2 = AlgebraicDivision(
        remainder: Algebraic.fromReal([1, -3, 6, 7.8]),
        quotient: Algebraic.fromReal([2, -9]),
      );

      expect(results2 == results, isTrue);
      expect(
        results ==
            AlgebraicDivision(
              remainder: Algebraic.fromReal([1, -3, 6, 7.8]),
              quotient: Algebraic.fromReal([2, -9]),
            ),
        isTrue,
      );

      expect(
        results.hashCode,
        equals(
          AlgebraicDivision(
            remainder: Algebraic.fromReal([1, -3, 6, 7.8]),
            quotient: Algebraic.fromReal([2, -9]),
          ).hashCode,
        ),
      );

      expect(
        results ==
            AlgebraicDivision(
              remainder: Algebraic.fromReal([1, -3, 6, 7.8]),
              quotient: Algebraic.fromReal([2, 9]),
            ),
        isFalse,
      );
    });
  });
}
