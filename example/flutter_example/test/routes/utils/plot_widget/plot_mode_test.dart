import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:test/test.dart';

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
        ).props.length,
        equals(1),
      );

      expect(
        PolynomialPlot(
          algebraic: Algebraic.fromReal([1, 4]),
        ).props.length,
        equals(1),
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
  });
}
