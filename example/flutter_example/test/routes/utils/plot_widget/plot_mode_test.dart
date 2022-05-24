import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PlotMode' analyzers", () {
    test('Making sure that objects comparison works properly', () {
      expect(
        PolynomialPlot(
          algebraic: Algebraic.fromReal([1, 4]),
        ),
        equals(
          PolynomialPlot(
            algebraic: Algebraic.fromReal([1, 4]),
          ),
        ),
      );

      expect(
        PolynomialPlot(
          algebraic: Algebraic.fromReal([1, 4]),
        ).hashCode,
        equals(
          PolynomialPlot(
            algebraic: Algebraic.fromReal([1, 4]),
          ).hashCode,
        ),
      );

      expect(
        const NonlinearPlot(
          nonLinear: Newton(
            function: 'x-3',
            x0: 1,
          ),
        ),
        equals(
          const NonlinearPlot(
            nonLinear: Newton(
              function: 'x-3',
              x0: 1,
            ),
          ),
        ),
      );

      expect(
        const NonlinearPlot(
          nonLinear: Newton(
            function: 'x-3',
            x0: 1,
          ),
        ).hashCode,
        equals(
          const NonlinearPlot(
            nonLinear: Newton(
              function: 'x-3',
              x0: 1,
            ),
          ).hashCode,
        ),
      );

      expect(
        const IntegralPlot(
          function: SimpsonRule(
            function: 'x-2',
            lowerBound: 1,
            upperBound: 2,
          ),
        ).hashCode,
        equals(
          const IntegralPlot(
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
        final plot = PolynomialPlot(
          algebraic: Algebraic.fromReal([1, -5]),
        );

        expect(plot.evaluateOn(-3), equals(-8));
      },
    );

    test(
      'Making sure that function evaluation works as expected with '
      'nonlinear equations.',
      () {
        const plot = NonlinearPlot(
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
        const plot = IntegralPlot(
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
