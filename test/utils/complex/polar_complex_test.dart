import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('Testing the behaviors of the PolarComplex class.', () {
    const polar = PolarComplex(r: 10, phiRadians: 2 * 3.14, phiDegrees: 360);

    test('Making that PolarComplex values are properly constructed.', () {
      expect(polar.r, equals(10));
      expect(polar.phiRadians, equals(2 * 3.14));
      expect(polar.phiDegrees, equals(360));
    });

    test('Making that PolarComplex is properly converted into a string.', () {
      const strResult = 'r = 10.0\n'
          'phi (rad) = 6.28\n'
          'phi (deg) = 360.0';

      expect(
        polar.toString(),
        equals(strResult),
      );
    });

    test('Making that PolarComplex can be properly compared.', () {
      const polar2 = PolarComplex(r: -4, phiRadians: 3.14, phiDegrees: 180);

      expect(polar2 == polar, isFalse);
      expect(
        polar2 == const PolarComplex(r: -4, phiRadians: 3.14, phiDegrees: 180),
        isTrue,
      );

      expect(
        polar.hashCode,
        equals(
          const PolarComplex(r: 10, phiRadians: 2 * 3.14, phiDegrees: 360)
              .hashCode,
        ),
      );
      expect(
        polar2.hashCode,
        equals(
          const PolarComplex(r: -4, phiRadians: 3.14, phiDegrees: 180).hashCode,
        ),
      );

      expect(polar2.compareTo(polar), equals(-1));
      expect(polar.compareTo(polar2), equals(1));
      expect(polar.compareTo(polar), equals(0));
      expect(polar2.compareTo(polar2), equals(0));
    });

    test('Making sure that copyWith clones objects correctly', () {
      const polarComplex = PolarComplex(r: 9, phiRadians: 1, phiDegrees: 2);

      // Objects equality
      expect(
        polarComplex,
        equals(
          polarComplex.copyWith(),
        ),
      );
      expect(
        polarComplex,
        equals(
          polarComplex.copyWith(r: 9, phiRadians: 1, phiDegrees: 2),
        ),
      );

      // Objects inequality
      expect(
        polarComplex == polarComplex.copyWith(r: 0),
        isFalse,
      );
    });
  });
}
