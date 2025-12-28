import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('PolynomialInterpolation', () {
    test(
      'Smoke test',
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
          equals(
            Quadratic.realEquation(
              a: -1 / 2,
              b: 5 / 2,
              c: -1,
            ),
          ),
        );
      },
    );

    test(
      'Smoke test 2',
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
      },
    );

    test(
      'Smoke test 3',
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
      },
    );

    test(
      'Smoke test 4',
      () {
        const interpolation = PolynomialInterpolation(
          nodes: [
            InterpolationNode(x: 2, y: 2),
            InterpolationNode(x: 3, y: 6),
            InterpolationNode(x: 4, y: 5),
            InterpolationNode(x: 5, y: 5),
            InterpolationNode(x: 6, y: 6),
          ],
        );

        final expected = Quartic.realEquation(
          a: -0.25,
          b: 4.5,
          c: -29.25,
          d: 81,
          e: -75,
        );
        expect(interpolation.buildPolynomial(), equals(expected));
      },
    );

    test('Object comparison.', () {
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
        const PolynomialInterpolation(
          nodes: [
            InterpolationNode(x: 1, y: 3),
            InterpolationNode(x: -2, y: 5),
          ],
        ),
        equals(interpolation),
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
        const PolynomialInterpolation(
              nodes: [
                InterpolationNode(x: 1, y: 3),
                InterpolationNode(x: -2, y: 5),
              ],
            ) ==
            interpolation,
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
        equals(
          const PolynomialInterpolation(
            nodes: [
              InterpolationNode(x: 1, y: 3),
              InterpolationNode(x: -2, y: 5),
            ],
          ).hashCode,
        ),
      );
    });

    test('Exception thrown for duplicate x-values', () {
      expect(
        () => const PolynomialInterpolation(
          nodes: [
            InterpolationNode(x: 1, y: 3),
            InterpolationNode(x: 1, y: 5), // Duplicate x-value
          ],
        ).compute(0),
        throwsA(isA<InterpolationException>()),
      );
    });

    test('Early return when x exactly matches a node x-value', () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 0, y: -1),
          InterpolationNode(x: 1, y: 1),
          InterpolationNode(x: 4, y: 1),
        ],
      );
      // When x exactly matches a node's x-value, return that node's y-value
      expect(interpolation.compute(0), equals(-1));
      expect(interpolation.compute(1), equals(1));
      expect(interpolation.compute(4), equals(1));
    });
  });
}
