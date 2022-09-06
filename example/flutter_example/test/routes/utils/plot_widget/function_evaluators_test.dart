import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/plot_widget/function_evaluators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PlotMode' analyzers", () {
    test('Making sure that objects comparison works properly', () {
      expect(
        PolynomialEvaluator(
          algebraic: Algebraic.fromReal([1, 4]),
        ),
        equals(
          PolynomialEvaluator(
            algebraic: Algebraic.fromReal([1, 4]),
          ),
        ),
      );

      expect(
        PolynomialEvaluator(
          algebraic: Algebraic.fromReal([1, 4]),
        ).hashCode,
        equals(
          PolynomialEvaluator(
            algebraic: Algebraic.fromReal([1, 4]),
          ).hashCode,
        ),
      );

      expect(
        const NonlinearEvaluator(
          nonLinear: Newton(
            function: 'x-3',
            x0: 1,
          ),
        ),
        equals(
          const NonlinearEvaluator(
            nonLinear: Newton(
              function: 'x-3',
              x0: 1,
            ),
          ),
        ),
      );

      expect(
        const NonlinearEvaluator(
          nonLinear: Newton(
            function: 'x-3',
            x0: 1,
          ),
        ).hashCode,
        equals(
          const NonlinearEvaluator(
            nonLinear: Newton(
              function: 'x-3',
              x0: 1,
            ),
          ).hashCode,
        ),
      );

      expect(
        const IntegralEvaluator(
          function: SimpsonRule(
            function: 'x-2',
            lowerBound: 1,
            upperBound: 2,
          ),
        ).hashCode,
        equals(
          const IntegralEvaluator(
            function: SimpsonRule(
              function: 'x-2',
              lowerBound: 1,
              upperBound: 2,
            ),
          ).hashCode,
        ),
      );
    });

    test(
      'Making sure that function evaluation works as expected with '
      'polynomial equations.',
      () {
        final plot = PolynomialEvaluator(
          algebraic: Algebraic.fromReal([1, -5]),
        );

        expect(plot.evaluateOn(-3), equals(-8));
      },
    );

    test(
      'Making sure that function evaluation works as expected with '
      'nonlinear equations.',
      () {
        const plot = NonlinearEvaluator(
          nonLinear: Newton(
            function: 'x-5',
            x0: 1,
          ),
        );

        expect(plot.evaluateOn(-3), equals(-8));
      },
    );

    test(
      'Making sure that function evaluation works as expected with '
      'integrals.',
      () {
        const plot = IntegralEvaluator(
          function: SimpsonRule(
            function: 'x',
            lowerBound: 1,
            upperBound: 2,
          ),
        );

        expect(plot.evaluateOn(5), equals(5));
      },
    );
  });
}
