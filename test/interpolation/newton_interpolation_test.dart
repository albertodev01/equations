import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'NewtonInterpolation' type", () {
    test(
        "Making sure that a 'NewtonInterpolation' object is properly constructed",
        () {
      const interpolation = NewtonInterpolation(
        nodes: [
          InterpolationNode(x: 45, y: 0.7071),
          InterpolationNode(x: 50, y: 0.7660),
          InterpolationNode(x: 55, y: 0.8192),
          InterpolationNode(x: 60, y: 0.8660),
        ],
      );

      expect(() => interpolation.nodes.clear(), throwsUnsupportedError);
      expect(interpolation.forwardDifference, isTrue);
      expect(interpolation.nodes.length, equals(4));
      expect(
        interpolation.nodes,
        orderedEquals(
          const [
            InterpolationNode(x: 45, y: 0.7071),
            InterpolationNode(x: 50, y: 0.7660),
            InterpolationNode(x: 55, y: 0.8192),
            InterpolationNode(x: 60, y: 0.8660),
          ],
        ),
      );

      expect(
        interpolation.compute(52),
        const MoreOrLessEquals(0.788, precision: 1.0e-3),
      );
    });

    test('Making sure that the forward differences table is correctly built',
        () {
      const interpolation = NewtonInterpolation(
        nodes: [
          InterpolationNode(x: 45, y: 0.7071),
          InterpolationNode(x: 50, y: 0.7660),
          InterpolationNode(x: 55, y: 0.8192),
          InterpolationNode(x: 60, y: 0.8660),
        ],
      );

      final forwardDiffTable = interpolation.forwardDifferenceTable();

      expect(
        forwardDiffTable(0, 0),
        const MoreOrLessEquals(0.707, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(1, 0),
        const MoreOrLessEquals(0.766, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(2, 0),
        const MoreOrLessEquals(0.819, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(3, 0),
        const MoreOrLessEquals(0.866, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(0, 1),
        const MoreOrLessEquals(0.058, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(1, 1),
        const MoreOrLessEquals(0.053, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(2, 1),
        const MoreOrLessEquals(0.046, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(3, 1),
        const MoreOrLessEquals(0, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(0, 2),
        const MoreOrLessEquals(-0.005, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(1, 2),
        const MoreOrLessEquals(-0.006, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(2, 2),
        const MoreOrLessEquals(0, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(3, 2),
        const MoreOrLessEquals(0, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(0, 3),
        const MoreOrLessEquals(-0.0007, precision: 1.0e-4),
      );
      expect(
        forwardDiffTable(1, 3),
        const MoreOrLessEquals(0, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(2, 3),
        const MoreOrLessEquals(0, precision: 1.0e-3),
      );
      expect(
        forwardDiffTable(3, 3),
        const MoreOrLessEquals(0, precision: 1.0e-3),
      );
    });

    test('Making sure that the backward differences table is correctly built',
        () {
      const interpolation = NewtonInterpolation(
        nodes: [
          InterpolationNode(x: 1891, y: 46),
          InterpolationNode(x: 1901, y: 66),
          InterpolationNode(x: 1911, y: 81),
          InterpolationNode(x: 1921, y: 93),
          InterpolationNode(x: 1931, y: 101),
        ],
      );

      final backwardDiffTable = interpolation.backwardDifferenceTable();

      expect(backwardDiffTable(0, 0), equals(46));
      expect(backwardDiffTable(0, 1), isZero);
      expect(backwardDiffTable(0, 2), isZero);
      expect(backwardDiffTable(0, 3), isZero);
      expect(backwardDiffTable(0, 4), isZero);
      expect(backwardDiffTable(1, 0), equals(66));
      expect(backwardDiffTable(1, 1), equals(20));
      expect(backwardDiffTable(1, 2), isZero);
      expect(backwardDiffTable(1, 3), isZero);
      expect(backwardDiffTable(1, 4), isZero);
      expect(backwardDiffTable(2, 0), equals(81));
      expect(backwardDiffTable(2, 1), equals(15));
      expect(backwardDiffTable(2, 2), equals(-5));
      expect(backwardDiffTable(2, 3), isZero);
      expect(backwardDiffTable(2, 4), isZero);
      expect(backwardDiffTable(3, 0), equals(93));
      expect(backwardDiffTable(3, 1), equals(12));
      expect(backwardDiffTable(3, 2), equals(-3));
      expect(backwardDiffTable(3, 3), equals(2));
      expect(backwardDiffTable(3, 4), isZero);
      expect(backwardDiffTable(4, 0), equals(101));
      expect(backwardDiffTable(4, 1), equals(8));
      expect(backwardDiffTable(4, 2), equals(-4));
      expect(backwardDiffTable(4, 3), equals(-1));
      expect(backwardDiffTable(4, 4), equals(-3));
    });
  });
}
