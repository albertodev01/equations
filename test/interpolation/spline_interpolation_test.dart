import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('SplineInterpolation', () {
    test(
      'Smoke test - MonotoneCubicSpline',
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
      'Smoke test - LinearSpline',
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

    test('Object comparison.', () {
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
        const SplineInterpolation(
          nodes: [
            InterpolationNode(x: 3, y: -2),
            InterpolationNode(x: 4, y: 1),
            InterpolationNode(x: 7, y: 0),
          ],
        ),
        equals(interpolation),
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
        const SplineInterpolation(
              nodes: [
                InterpolationNode(x: 3, y: -2),
                InterpolationNode(x: 4, y: 1),
                InterpolationNode(x: 7, y: 0),
              ],
            ) ==
            interpolation,
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
        equals(
          const SplineInterpolation(
            nodes: [
              InterpolationNode(x: 3, y: -2),
              InterpolationNode(x: 4, y: 1),
              InterpolationNode(x: 7, y: 0),
            ],
          ).hashCode,
        ),
      );
    });
  });
}
