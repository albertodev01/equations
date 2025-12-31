import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';
import 'package:test/test.dart';

void main() {
  group('SplineFunction', () {
    test(
      'Exception thrown when control points do not have increasing x values',
      () {
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
      },
    );

    test(
      'Exception thrown when less than 2 control points in the list.',
      () {
        expect(
          () => SplineFunction.generate(
            nodes: const [
              InterpolationNode(x: 3, y: 6),
            ],
          ),
          throwsA(isA<InterpolationException>()),
        );
      },
    );

    test(
      'MonotoneCubicSpline returned when nodes are monotonic.',
      () {
        expect(
          SplineFunction.generate(
            nodes: const [
              InterpolationNode(x: 3, y: -2),
              InterpolationNode(x: 4, y: 1),
            ],
          ),
          isA<MonotoneCubicSpline>(),
        );
      },
    );

    test(
      'LinearSpline returned when nodes are not monotonic.',
      () {
        expect(
          SplineFunction.generate(
            nodes: const [
              InterpolationNode(x: 3, y: -2),
              InterpolationNode(x: 4, y: 1),
              InterpolationNode(x: 7, y: 0),
            ],
          ),
          isA<LinearSpline>(),
        );
      },
    );
  });
}
