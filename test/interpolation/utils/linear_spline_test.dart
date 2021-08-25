import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'LinearSpline' class", () {
    test(
        'Making sure that cubic spline interpolation works correctly (test '
        'points - set 1).', () {
      const linear = LinearSpline(
        nodes: [
          InterpolationNode(x: 3, y: -6),
          InterpolationNode(x: 4, y: -2),
          InterpolationNode(x: 5, y: 1),
        ],
      );

      expect('$linear', equals('(3.0; -6.0), (4.0; -2.0), (5.0; 1.0)'));

      expect(linear.interpolate(8), equals(1));
      expect(linear.interpolate(-5), equals(-6));
      expect(linear.interpolate(0), equals(-6));

      // Testing known values
      expect(linear.interpolate(3), equals(-6));
      expect(linear.interpolate(4), equals(-2));
      expect(linear.interpolate(5), equals(1));
    });

    test(
        'Making sure that cubic spline interpolation works correctly (test '
        'points - set 2).', () {
      const linear = LinearSpline(
        nodes: [
          InterpolationNode(x: -2, y: 0),
          InterpolationNode(x: 3, y: 2),
          InterpolationNode(x: 4, y: 6),
          InterpolationNode(x: 6, y: 7),
          InterpolationNode(x: 10, y: 15),
        ],
      );

      expect(
        '$linear',
        equals('(-2.0; 0.0), (3.0; 2.0), (4.0; 6.0), (6.0; 7.0), (10.0; 15.0)'),
      );

      expect(linear.interpolate(0), equals(0.8));
      expect(linear.interpolate(-3), isZero);
      expect(linear.interpolate(5), equals(6.5));
      expect(linear.interpolate(11), equals(15));

      // Testing known values
      expect(linear.interpolate(-2), isZero);
      expect(linear.interpolate(3), equals(2));
      expect(linear.interpolate(4), equals(6));
      expect(linear.interpolate(6), equals(7));
      expect(linear.interpolate(10), equals(15));
    });

    test('Making sure that objects comparison works properly', () {
      const linearInterpolation = LinearSpline(
        nodes: [
          InterpolationNode(x: -2, y: 0),
          InterpolationNode(x: 3, y: 2),
          InterpolationNode(x: 4, y: 6),
          InterpolationNode(x: 6, y: 7),
          InterpolationNode(x: 10, y: 15),
        ],
      );

      expect(
        linearInterpolation,
        equals(
          const LinearSpline(
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
        linearInterpolation ==
            const LinearSpline(
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
        linearInterpolation ==
            const LinearSpline(
              nodes: [
                InterpolationNode(x: -2, y: 0),
                InterpolationNode(x: 3, y: 2),
                InterpolationNode(x: 5, y: 6),
                InterpolationNode(x: 6, y: 7),
                InterpolationNode(x: 10, y: 15),
              ],
            ),
        isFalse,
      );

      expect(
        linearInterpolation ==
            const LinearSpline(
              nodes: [
                InterpolationNode(x: -2, y: 0),
                InterpolationNode(x: 3, y: 2),
                InterpolationNode(x: 4, y: 6),
                InterpolationNode(x: 6, y: 7),
              ],
            ),
        isFalse,
      );

      expect(
        linearInterpolation == linearInterpolation,
        isTrue,
      );

      expect(
        linearInterpolation.hashCode,
        equals(const LinearSpline(
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
