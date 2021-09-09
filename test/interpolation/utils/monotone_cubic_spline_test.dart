import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the 'MonotoneCubicSpline' class", () {
    test(
      'Making sure that cubic spline interpolation works correctly (test '
      'points - set 1).',
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: 3, y: -6),
            InterpolationNode(x: 4, y: -2),
            InterpolationNode(x: 5, y: 1),
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
      'Making sure that cubic spline interpolation works correctly (test '
      'points - set 2).',
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: -2, y: 0),
            InterpolationNode(x: 3, y: 2),
            InterpolationNode(x: 4, y: 6),
            InterpolationNode(x: 6, y: 7),
            InterpolationNode(x: 10, y: 15),
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
      'Making sure that cubic spline interpolation works correctly (test '
      'points - set 3).',
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: 3, y: -6),
            InterpolationNode(x: 4, y: -2),
            InterpolationNode(x: 5, y: 1),
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
      'Making sure that cubic spline interpolation works correctly (test '
      'points - set 4).',
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: -2, y: 0),
            InterpolationNode(x: 3, y: 2),
            InterpolationNode(x: 4, y: 6),
            InterpolationNode(x: 6, y: 7),
            InterpolationNode(x: 10, y: 15),
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
      'Making sure that cubic spline interpolation works correctly (test '
      'points - set 5).',
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: 0, y: 0),
            InterpolationNode(x: 1, y: 1),
            InterpolationNode(x: 2, y: 6),
          ],
        );

        expect(cubic.interpolate(5), equals(6));
      },
    );

    test('Making sure that Hermite spline interpolation correctly works.', () {
      const cubic = MonotoneCubicSpline(
        nodes: [
          InterpolationNode(x: 1, y: -1),
          InterpolationNode(x: 5, y: 6),
          InterpolationNode(x: 13, y: 12),
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
      'Making sure that when 2 nodes have the same "y" value, the "nodesM" '
      'array manually sets values to zero',
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: -2, y: 0),
            InterpolationNode(x: 3, y: 2),
            InterpolationNode(x: 4, y: 2),
          ],
        );

        // Testing known values
        expect(cubic.interpolate(-2), isZero);
        expect(cubic.interpolate(3), equals(2));
        expect(cubic.interpolate(4), equals(2));
      },
    );

    test(
      'Making sure that an exception is thrown if the given control points '
      "don't have increasing 'x' values",
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: -2, y: 0),
            InterpolationNode(x: -10, y: 2),
            InterpolationNode(x: 0, y: 6),
          ],
        );

        expect(
          () => cubic.interpolate(1),
          throwsA(isA<InterpolationException>()),
        );
      },
    );

    test(
      'Making sure that an exception is thrown if the given control points '
      "don't have increasing 'y' values",
      () {
        const cubic = MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: -2, y: -6),
            InterpolationNode(x: 1, y: -1),
            InterpolationNode(x: 4, y: -2),
          ],
        );

        expect(
          () => cubic.interpolate(1),
          throwsA(isA<InterpolationException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly', () {
      const cubicInterpolation = MonotoneCubicSpline(
        nodes: [
          InterpolationNode(x: -2, y: 0),
          InterpolationNode(x: 3, y: 2),
          InterpolationNode(x: 4, y: 6),
          InterpolationNode(x: 6, y: 7),
          InterpolationNode(x: 10, y: 15),
        ],
      );

      expect(
        cubicInterpolation,
        equals(
          const MonotoneCubicSpline(
            nodes: [
              InterpolationNode(x: -2, y: 0),
              InterpolationNode(x: 3, y: 2),
              InterpolationNode(x: 4, y: 6),
              InterpolationNode(x: 6, y: 7),
              InterpolationNode(x: 10, y: 15),
            ],
          ),
        ),
      );

      expect(
        cubicInterpolation ==
            const MonotoneCubicSpline(
              nodes: [
                InterpolationNode(x: -2, y: 0),
                InterpolationNode(x: 3, y: 2),
                InterpolationNode(x: 4, y: 6),
                InterpolationNode(x: 6, y: 7),
                InterpolationNode(x: 10, y: 15),
              ],
            ),
        isTrue,
      );

      expect(
        cubicInterpolation ==
            const MonotoneCubicSpline(
              nodes: [
                InterpolationNode(x: 2, y: 0),
                InterpolationNode(x: 3, y: 2),
                InterpolationNode(x: 4, y: 6),
                InterpolationNode(x: 6, y: 7),
                InterpolationNode(x: -10, y: -15),
              ],
            ),
        isFalse,
      );

      expect(
        cubicInterpolation ==
            const MonotoneCubicSpline(
              nodes: [
                InterpolationNode(x: 2, y: 0),
                InterpolationNode(x: 3, y: 2),
                InterpolationNode(x: 4, y: 6),
                InterpolationNode(x: 6, y: 7),
                InterpolationNode(x: 10, y: 15),
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
        equals(const MonotoneCubicSpline(
          nodes: [
            InterpolationNode(x: -2, y: 0),
            InterpolationNode(x: 3, y: 2),
            InterpolationNode(x: 4, y: 6),
            InterpolationNode(x: 6, y: 7),
            InterpolationNode(x: 10, y: 15),
          ],
        ).hashCode),
      );
    });
  });
}
