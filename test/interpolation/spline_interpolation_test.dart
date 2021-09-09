import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'SplineInterpolation' class", () {
    test(
      'Making sure that, when the given nodes are monotonic, interpolation '
      'happens with the "MonotoneCubicSpline" class.',
      () {
        const spline = SplineInterpolation(
          nodes: [
            InterpolationNode(x: 3, y: -2),
            InterpolationNode(x: 4, y: 1),
            InterpolationNode(x: 7, y: 3),
          ],
        );

        expect(spline.compute(8), equals(3));
        expect(spline.compute(-11), equals(-2));
      },
    );

    test(
      'Making sure that, when the given nodes are monotonic, interpolation '
      'happens with the "LinearSpline" class.',
      () {
        const spline = SplineInterpolation(
          nodes: [
            InterpolationNode(x: 3, y: -2),
            InterpolationNode(x: 4, y: 1),
            InterpolationNode(x: 7, y: 0),
          ],
        );

        expect(spline.compute(4), equals(1));
        expect(spline.compute(-3), equals(-2));
      },
    );

    test('Making sure that objects comparison works properly', () {
      const interpolation = SplineInterpolation(
        nodes: [
          InterpolationNode(x: 3, y: -2),
          InterpolationNode(x: 4, y: 1),
          InterpolationNode(x: 7, y: 0),
        ],
      );

      expect(
        interpolation,
        equals(
          const SplineInterpolation(
            nodes: [
              InterpolationNode(x: 3, y: -2),
              InterpolationNode(x: 4, y: 1),
              InterpolationNode(x: 7, y: 0),
            ],
          ),
        ),
      );

      expect(
        interpolation ==
            const SplineInterpolation(
              nodes: [
                InterpolationNode(x: 3, y: -2),
                InterpolationNode(x: 4, y: 1),
                InterpolationNode(x: 7, y: 0),
              ],
            ),
        isTrue,
      );

      expect(
        interpolation ==
            const SplineInterpolation(
              nodes: [
                InterpolationNode(x: 3, y: -2),
                InterpolationNode(x: 4, y: 1),
                InterpolationNode(x: 7, y: 9),
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
        equals(const SplineInterpolation(
          nodes: [
            InterpolationNode(x: 3, y: -2),
            InterpolationNode(x: 4, y: 1),
            InterpolationNode(x: 7, y: 0),
          ],
        ).hashCode),
      );
    });
  });
}
