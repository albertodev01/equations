import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'SplineFunction' class", () {
    test(
        'Making sure that an exception is thrown when the control points do '
        'NOT have increasing values on the "x" coordinate', () {
      expect(
        () => SplineFunction.generate(
          nodes: const [
            InterpolationNode(x: 3, y: 6),
            InterpolationNode(x: 4, y: -2),
            InterpolationNode(x: 2, y: 1),
          ],
        ),
        throwsA(isA<InterpolationException>()),
      );
    });

    test(
        'Making sure that an exception is thrown when there are less than 2 '
        'control points in the nodes list.', () {
      expect(
        () => SplineFunction.generate(nodes: const [
          InterpolationNode(x: 3, y: 6),
        ]),
        throwsA(isA<InterpolationException>()),
      );
    });

    test(
        'Making sure that "MonotoneCubicSpline" is returned when the given '
        'nodes are monotonic.', () {
      expect(
          SplineFunction.generate(
            nodes: const [
              InterpolationNode(x: 3, y: -2),
              InterpolationNode(x: 4, y: 1),
            ],
          ),
          isA<MonotoneCubicSpline>());
    });

    test(
        'Making sure that "MonotoneCubicSpline" is returned when the given '
        'nodes are NOT monotonic.', () {
      expect(
          SplineFunction.generate(
            nodes: const [
              InterpolationNode(x: 3, y: -2),
              InterpolationNode(x: 4, y: 1),
              InterpolationNode(x: 7, y: 0),
            ],
          ),
          isA<LinearSpline>());
    });
  });
}
