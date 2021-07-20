import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'LinearInterpolation' type", () {
    test(
        "Making sure that a 'LinearInterpolation' object is properly constructed",
        () {
      final interpolation = LinearInterpolation(
        nodes: const [
          InterpolationNode(x: 1, y: 3),
          InterpolationNode(x: -2, y: 5),
        ],
      );

      expect(() => interpolation.nodes.clear(), throwsUnsupportedError);
      expect(interpolation.nodes.length, equals(2));
      expect(
        interpolation.nodes,
        orderedEquals(
          const [
            InterpolationNode(x: 1, y: 3),
            InterpolationNode(x: -2, y: 5),
          ],
        ),
      );

      expect(interpolation.compute(7), equals(-1));
      expect(
        interpolation.compute(-2.5),
        const MoreOrLessEquals(5.33, precision: 1.0e-2),
      );
    });

    test("Making sure that an exception is thrown when nodes aren't 2", () {
      expect(
        () => LinearInterpolation(nodes: const [
          InterpolationNode(x: 1, y: 3),
        ]),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => LinearInterpolation(nodes: const [
          InterpolationNode(x: 1, y: 3),
          InterpolationNode(x: 2, y: 4),
          InterpolationNode(x: 5, y: 6),
        ]),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Making sure that objects comparison works properly', () {
      final interpolation = LinearInterpolation(
        nodes: const [
          InterpolationNode(x: 1, y: 3),
          InterpolationNode(x: -2, y: 5),
        ],
      );

      expect(
        interpolation,
        equals(
          LinearInterpolation(
            nodes: const [
              InterpolationNode(x: 1, y: 3),
              InterpolationNode(x: -2, y: 5),
            ],
          ),
        ),
      );

      expect(
        interpolation ==
            LinearInterpolation(
              nodes: const [
                InterpolationNode(x: 1, y: 3),
                InterpolationNode(x: -2, y: 5),
              ],
            ),
        isTrue,
      );

      expect(
        interpolation ==
            LinearInterpolation(
              nodes: const [
                InterpolationNode(x: -1, y: 3),
                InterpolationNode(x: -2, y: 5),
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
        equals(LinearInterpolation(
          nodes: const [
            InterpolationNode(x: 1, y: 3),
            InterpolationNode(x: -2, y: 5),
          ],
        ).hashCode),
      );
    });
  });
}
