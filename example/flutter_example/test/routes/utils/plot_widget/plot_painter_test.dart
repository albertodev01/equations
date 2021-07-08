import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PlotPainter' class", () {
    Widget _buildPolynomialPainter(int range) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: CustomPaint(
          painter: PlotterPainter(
            plotMode:
                PolynomialPlot(algebraic: Algebraic.fromReal([1, 2, -3, -2])),
            range: range,
          ),
          size: const Size.square(200),
        ),
      );
    }

    Widget _buildNonlinearPainter(int range) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: CustomPaint(
          painter: PlotterPainter(
            plotMode: const NonlinearPlot(
              nonLinear: Newton(function: 'e^x+x^3', x0: -1),
            ),
            range: range,
          ),
          size: const Size.square(200),
        ),
      );
    }

    testGoldens('PlotPainter - Polynomial', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('Polynomial - low range', _buildPolynomialPainter(2))
        ..addScenario('Polynomial - default', _buildPolynomialPainter(5))
        ..addScenario('Polynomial - high range', _buildPolynomialPainter(9));

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 900),
      );
      await screenMatchesGolden(tester, 'polynomial_plot_painter');
    });

    testGoldens('PlotPainter - Polynomial', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('Nonlinear - low range', _buildNonlinearPainter(2))
        ..addScenario('Nonlinear - default', _buildNonlinearPainter(5))
        ..addScenario('Nonlinear - high range', _buildNonlinearPainter(9));

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 900),
      );
      await screenMatchesGolden(tester, 'nonlinear_plot_painter');
    });
  });
}
