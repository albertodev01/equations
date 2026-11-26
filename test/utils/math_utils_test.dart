import 'package:equations/src/utils/math_utils.dart';
import 'package:test/test.dart';

void main() {
  group('hypot()', () {
    test('Computes sqrt(x^2 + y^2)', () {
      expect(hypot(0, 0), isZero);
      expect(hypot(0, 8), equals(8));
      expect(hypot(8, 0), equals(8));
      expect(hypot(3, 4), equals(5));
      expect(hypot(-3, 4), equals(5));
      expect(hypot(3, -4), equals(5));
    });

    test('Does not overflow or underflow with extreme values', () {
      // Squaring these values directly would give infinity and zero.
      expect(hypot(3e300, 4e300), closeTo(5e300, 1e286));
      expect(hypot(3e-300, 4e-300), closeTo(5e-300, 1e-314));
    });

    test('Infinite and NaN values', () {
      const inf = double.infinity;

      expect(hypot(inf, 1), equals(inf));
      expect(hypot(1, -inf), equals(inf));
      expect(hypot(inf, inf), equals(inf));
      expect(hypot(inf, double.nan), equals(inf));
      expect(hypot(double.nan, -inf), equals(inf));
      expect(hypot(double.nan, 1), isNaN);
    });
  });
}
