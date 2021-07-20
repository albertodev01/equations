import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'PolynomialInterpolation' type", () {
    test(
        "Making sure that a 'PolynomialInterpolation' object is properly constructed",
        () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 0, y: -1),
          InterpolationNode(x: 1, y: 1),
          InterpolationNode(x: 4, y: 1),
        ],
      );

      expect(() => interpolation.nodes.clear(), throwsUnsupportedError);
      expect(interpolation.nodes.length, equals(3));
      expect(
        interpolation.nodes,
        orderedEquals(
          const [
            InterpolationNode(x: 0, y: -1),
            InterpolationNode(x: 1, y: 1),
            InterpolationNode(x: 4, y: 1),
          ],
        ),
      );

      expect(interpolation.compute(3), equals(2));
      expect(
        interpolation.compute(-1.15),
        const MoreOrLessEquals(-4.54, precision: 1.0e-2),
      );
      expect(
        interpolation.buildPolynomial(),
        equals(Quadratic.realEquation(
          a: -1 / 2,
          b: 5 / 2,
          c: -1,
        )),
      );
    });

    test('Making sure that the interpolating poly is correctly generated (1)',
        () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 4, y: 2),
          InterpolationNode(x: 2, y: 5),
          InterpolationNode(x: 1, y: 2),
        ],
      );

      final expected = Algebraic.fromReal([-3 / 2, 15 / 2, -4]);
      expect(interpolation.buildPolynomial(), equals(expected));
    });

    test('Making sure that the interpolating poly is correctly generated (2)',
        () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 1, y: 0),
          InterpolationNode(x: -1, y: -3),
          InterpolationNode(x: 2, y: 4),
        ],
      );

      final expected = Quadratic.realEquation(
        a: 5 / 6,
        b: 3 / 2,
        c: -14 / 6,
      );
      expect(interpolation.buildPolynomial(), equals(expected));
    });

    test('Making sure that objects comparison works properly', () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 1, y: 3),
          InterpolationNode(x: -2, y: 5),
        ],
      );

      expect(
        interpolation,
        equals(
          const PolynomialInterpolation(
            nodes: [
              InterpolationNode(x: 1, y: 3),
              InterpolationNode(x: -2, y: 5),
            ],
          ),
        ),
      );

      expect(
        interpolation ==
            const PolynomialInterpolation(
              nodes: [
                InterpolationNode(x: 1, y: 3),
                InterpolationNode(x: -2, y: 5),
              ],
            ),
        isTrue,
      );

      expect(
        interpolation ==
            const PolynomialInterpolation(
              nodes: [
                InterpolationNode(x: 1, y: 3),
                InterpolationNode(x: 2, y: 5),
              ],
            ),
        isFalse,
      );

      expect(
        interpolation == interpolation,
        isTrue,
      );

      expect(
        interpolation.hashCode,
        equals(const PolynomialInterpolation(
          nodes: [
            InterpolationNode(x: 1, y: 3),
            InterpolationNode(x: -2, y: 5),
          ],
        ).hashCode),
      );
    });
  });
}
