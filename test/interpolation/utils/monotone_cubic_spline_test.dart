import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('MonotoneCubicSpline', () {
    test(
      'Smoke test',
      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: 3, y: -6),
            const InterpolationNode(x: 4, y: -2),
            const InterpolationNode(x: 5, y: 1),
          ],
        );

        expect(
          '$cubic',
          equals('(3.0; -6.0), (4.0; -2.0), (5.0; 1.0)'),
        );

        expect(cubic.interpolate(8), equals(1));
        expect(cubic.interpolate(-5), equals(-6));
        expect(cubic.interpolate(0), equals(-6));

        // Testing known values
        expect(cubic.interpolate(3), equals(-6));
        expect(cubic.interpolate(4), equals(-2));
        expect(cubic.interpolate(5), equals(1));
      },
    );

    test(
      'Smoke test 2',
      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: -2, y: 0),
            const InterpolationNode(x: 3, y: 2),
            const InterpolationNode(x: 4, y: 6),
            const InterpolationNode(x: 6, y: 7),
            const InterpolationNode(x: 10, y: 15),
          ],
        );

        expect(
          '$cubic',
          equals(
            '(-2.0; 0.0), (3.0; 2.0), (4.0; 6.0), (6.0; 7.0), (10.0; 15.0)',
          ),
        );

        expect(
          cubic.interpolate(0),
          const MoreOrLessEquals(0.29184, precision: 1.0e-5),
        );
        expect(
          cubic.interpolate(-3),
          isZero,
        );
        expect(
          cubic.interpolate(2),
          const MoreOrLessEquals(1.07073, precision: 1.0e-5),
        );
        expect(
          cubic.interpolate(5),
          const MoreOrLessEquals(6.64569, precision: 1.0e-5),
        );
        expect(
          cubic.interpolate(11),
          equals(15),
        );

        // Testing known values
        expect(cubic.interpolate(-2), isZero);
        expect(cubic.interpolate(3), equals(2));
        expect(cubic.interpolate(4), equals(6));
        expect(cubic.interpolate(6), equals(7));
        expect(cubic.interpolate(10), equals(15));
      },
    );

    test(
      'Smoke test 3',
      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: 3, y: -6),
            const InterpolationNode(x: 4, y: -2),
            const InterpolationNode(x: 5, y: 1),
          ],
        );

        expect('$cubic', equals('(3.0; -6.0), (4.0; -2.0), (5.0; 1.0)'));

        expect(cubic.interpolate(8), equals(1));
        expect(cubic.interpolate(-5), equals(-6));
        expect(cubic.interpolate(0), equals(-6));

        // Testing known values
        expect(cubic.interpolate(3), equals(-6));
        expect(cubic.interpolate(4), equals(-2));
        expect(cubic.interpolate(5), equals(1));
      },
    );

    test(
      'Smoke test 4',
      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: -2, y: 0),
            const InterpolationNode(x: 3, y: 2),
            const InterpolationNode(x: 4, y: 6),
            const InterpolationNode(x: 6, y: 7),
            const InterpolationNode(x: 10, y: 15),
          ],
        );

        expect(
          '$cubic',
          equals(
            '(-2.0; 0.0), (3.0; 2.0), (4.0; 6.0), (6.0; 7.0), (10.0; 15.0)',
          ),
        );

        expect(
          cubic.interpolate(0),
          const MoreOrLessEquals(0.29184, precision: 1.0e-5),
        );
        expect(cubic.interpolate(-3), isZero);
        expect(
          cubic.interpolate(5),
          const MoreOrLessEquals(6.64569, precision: 1.0e-5),
        );
        expect(cubic.interpolate(11), equals(15));

        // Testing known values
        expect(cubic.interpolate(-2), isZero);
        expect(cubic.interpolate(3), equals(2));
        expect(cubic.interpolate(4), equals(6));
        expect(cubic.interpolate(6), equals(7));
        expect(cubic.interpolate(10), equals(15));
      },
    );

    test(
      'Smoke test 5',

      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: 0, y: 0),
            const InterpolationNode(x: 1, y: 1),
            const InterpolationNode(x: 2, y: 6),
          ],
        );

        expect(cubic.interpolate(5), equals(6));
      },
    );

    test('Hermite spline interpolation correctly works.', () {
      final cubic = MonotoneCubicSpline(
        nodes: [
          const InterpolationNode(x: 1, y: -1),
          const InterpolationNode(x: 5, y: 6),
          const InterpolationNode(x: 13, y: 12),
        ],
      );

      expect(cubic.interpolate(5), equals(6));
      expect(cubic.interpolate(9), equals(9.5));

      // Testing known values
      expect(cubic.interpolate(1), equals(-1));
      expect(cubic.interpolate(5), equals(6));
      expect(cubic.interpolate(13), equals(12));
    });

    test(
      'When 2 nodes have same y value, nodesM array sets values to 0',
      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: -2, y: 0),
            const InterpolationNode(x: 3, y: 2),
            const InterpolationNode(x: 4, y: 2),
          ],
        );

        // Testing known values
        expect(cubic.interpolate(-2), isZero);
        expect(cubic.interpolate(3), equals(2));
        expect(cubic.interpolate(4), equals(2));
      },
    );

    test(
      'Exception thrown if control points do not have increasing x values',
      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: -2, y: 0),
            const InterpolationNode(x: -10, y: 2),
            const InterpolationNode(x: 0, y: 6),
          ],
        );

        expect(
          () => cubic.interpolate(1),
          throwsA(isA<InterpolationException>()),
        );
      },
    );

    test(
      'Exception thrown if control points do not have increasing y values',
      () {
        final cubic = MonotoneCubicSpline(
          nodes: [
            const InterpolationNode(x: -2, y: -6),
            const InterpolationNode(x: 1, y: -1),
            const InterpolationNode(x: 4, y: -2),
          ],
        );

        expect(
          () => cubic.interpolate(1),
          throwsA(isA<InterpolationException>()),
        );
      },
    );

    test('Object comparison.', () {
      final cubicInterpolation = MonotoneCubicSpline(
        nodes: [
          const InterpolationNode(x: -2, y: 0),
          const InterpolationNode(x: 3, y: 2),
          const InterpolationNode(x: 4, y: 6),
          const InterpolationNode(x: 6, y: 7),
          const InterpolationNode(x: 10, y: 15),
        ],
      );

      expect(
        cubicInterpolation,
        equals(
          MonotoneCubicSpline(
            nodes: [
              const InterpolationNode(x: -2, y: 0),
              const InterpolationNode(x: 3, y: 2),
              const InterpolationNode(x: 4, y: 6),
              const InterpolationNode(x: 6, y: 7),
              const InterpolationNode(x: 10, y: 15),
            ],
          ),
        ),
      );

      expect(
        cubicInterpolation ==
            MonotoneCubicSpline(
              nodes: [
                const InterpolationNode(x: -2, y: 0),
                const InterpolationNode(x: 3, y: 2),
                const InterpolationNode(x: 4, y: 6),
                const InterpolationNode(x: 6, y: 7),
                const InterpolationNode(x: 10, y: 15),
              ],
            ),
        isTrue,
      );

      expect(
        cubicInterpolation ==
            MonotoneCubicSpline(
              nodes: [
                const InterpolationNode(x: 2, y: 0),
                const InterpolationNode(x: 3, y: 2),
                const InterpolationNode(x: 4, y: 6),
                const InterpolationNode(x: 6, y: 7),
                const InterpolationNode(x: -10, y: -15),
              ],
            ),
        isFalse,
      );

      expect(
        cubicInterpolation ==
            MonotoneCubicSpline(
              nodes: [
                const InterpolationNode(x: 2, y: 0),
                const InterpolationNode(x: 3, y: 2),
                const InterpolationNode(x: 4, y: 6),
                const InterpolationNode(x: 6, y: 7),
                const InterpolationNode(x: 10, y: 15),
              ],
            ),
        isFalse,
      );

      expect(
        cubicInterpolation == cubicInterpolation,
        isTrue,
      );

      expect(
        cubicInterpolation.hashCode,
        equals(
          MonotoneCubicSpline(
            nodes: [
              const InterpolationNode(x: -2, y: 0),
              const InterpolationNode(x: 3, y: 2),
              const InterpolationNode(x: 4, y: 6),
              const InterpolationNode(x: 6, y: 7),
              const InterpolationNode(x: 10, y: 15),
            ],
          ).hashCode,
        ),
      );
    });
  });
}
