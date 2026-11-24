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

        final polynomial = interpolation.buildPolynomial();

        expect(polynomial, isA<Quadratic>());
        expect(
          polynomial.coefficients.map((c) => c.real).toList(),
          pairwiseCompare<double, double>(
            const [5 / 6, 3 / 2, -14 / 6],
            (actual, expected) => (actual - expected).abs() <= 1.0e-12,
            'within 1.0e-12 of',
          ),
        );
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

    test('buildPolynomial with collinear nodes returns a line', () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 0, y: 0),
          InterpolationNode(x: 1, y: 1),
          InterpolationNode(x: 2, y: 2),
        ],
      );

      final polynomial = interpolation.buildPolynomial();

      expect(polynomial, isA<Linear>());
      expect(polynomial.degree, equals(1));
      expect(polynomial.realEvaluateOn(5).real, const MoreOrLessEquals(5));
    });

    test('buildPolynomial drops negligible leading coefficients', () {
      // The nodes lie on y = 2x + 0.1, but the LU solver returns tiny non-zero
      // values for the x^3 and x^2 coefficients
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 0.1, y: 0.3),
          InterpolationNode(x: 0.2, y: 0.5),
          InterpolationNode(x: 0.7, y: 1.5),
          InterpolationNode(x: 1.3, y: 2.7),
        ],
      );

      final polynomial = interpolation.buildPolynomial();

      expect(polynomial.degree, equals(1));
      expect(
        polynomial.coefficients.first.real,
        const MoreOrLessEquals(2),
      );
      expect(
        polynomial.coefficients.last.real,
        const MoreOrLessEquals(0.1),
      );
    });

    test('buildPolynomial with constant nodes returns a constant', () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 1, y: 2),
          InterpolationNode(x: 2, y: 2),
          InterpolationNode(x: 3, y: 2),
        ],
      );

      final polynomial = interpolation.buildPolynomial();

      expect(polynomial, isA<Constant>());
      expect(polynomial.realEvaluateOn(10).real, const MoreOrLessEquals(2));
    });

    test('buildPolynomial with all y values zero returns zero', () {
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: -1, y: 0),
          InterpolationNode(x: 2, y: 0),
          InterpolationNode(x: 5, y: 0),
        ],
      );

      final polynomial = interpolation.buildPolynomial();

      expect(polynomial, isA<Constant>());
      expect(polynomial.realEvaluateOn(3).real, const MoreOrLessEquals(0));
    });

    test('buildPolynomial keeps a small but significant leading term', () {
      // y = 1.0e-6 * x^2 + 1, the x^2 term changes y by 1.0e-4 at x = 10
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 0, y: 1),
          InterpolationNode(x: 5, y: 1.000025),
          InterpolationNode(x: 10, y: 1.0001),
        ],
      );

      final polynomial = interpolation.buildPolynomial();

      expect(polynomial.degree, equals(2));
      expect(
        polynomial.coefficients.first.real,
        const MoreOrLessEquals(1.0e-6),
      );
    });

    test('buildPolynomial works with unsorted nodes', () {
      // The nodes lie on y = x^3 + 2x^2 + 3x + 1
      const interpolation = PolynomialInterpolation(
        nodes: [
          InterpolationNode(x: 3, y: 55),
          InterpolationNode(x: 0, y: 1),
          InterpolationNode(x: 4, y: 109),
          InterpolationNode(x: 1, y: 7),
          InterpolationNode(x: 2, y: 23),
        ],
      );

      final coefficients = interpolation
          .buildPolynomial()
          .coefficients
          .map((c) => c.real)
          .toList(growable: false);

      expect(coefficients.length, equals(4));
      expect(coefficients[0], const MoreOrLessEquals(1));
      expect(coefficients[1], const MoreOrLessEquals(2));
      expect(coefficients[2], const MoreOrLessEquals(3));
      expect(coefficients[3], const MoreOrLessEquals(1));
    });

    test('buildPolynomial works with many nodes in a small interval', () {
      // 12 nodes in [0, 1] taken from y = 1 + 2x - x^2 + 0.5x^3
      final nodes = List<InterpolationNode>.generate(12, (i) {
        final x = i / 11;

        return InterpolationNode(x: x, y: 1 + 2 * x - x * x + 0.5 * x * x * x);
      });

      final polynomial = PolynomialInterpolation(nodes: nodes)
          .buildPolynomial();
      final coefficients = polynomial.coefficients
          .map((c) => c.real)
          .toList(growable: false)
          .reversed
          .toList(growable: false);

      // The result has degree 11 in theory, but all the coefficients above x^3
      // must be (almost) zero
      expect(coefficients[0], const MoreOrLessEquals(1, precision: 1.0e-9));
      expect(coefficients[1], const MoreOrLessEquals(2, precision: 1.0e-7));
      expect(coefficients[2], const MoreOrLessEquals(-1, precision: 1.0e-6));
      expect(coefficients[3], const MoreOrLessEquals(0.5, precision: 1.0e-5));

      for (final node in nodes) {
        expect(
          polynomial.realEvaluateOn(node.x).real,
          MoreOrLessEquals(node.y),
        );
      }
    });
  });
}
