import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/plot_widget/color_area.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PlotPainter' class", () {
    Widget _buildPolynomialPainter({
      int range = 5,
      ColorArea colorArea = const ColorArea(
        startPoint: 5,
        endPoint: 5,
      ),
    }) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: CustomPaint(
          painter: PlotterPainter(
            plotMode: PolynomialPlot(
              algebraic: Algebraic.fromReal([1, 2, -3, -2]),
            ),
            range: range,
            colorArea: colorArea,
          ),
          size: const Size.square(200),
        ),
      );
    }

    Widget _buildNonlinearPainter({
      int range = 5,
      ColorArea colorArea = const ColorArea(
        startPoint: 5,
        endPoint: 5,
      ),
    }) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: CustomPaint(
          painter: PlotterPainter(
            plotMode: const NonlinearPlot(
              nonLinear: Newton(function: 'e^x+x^3', x0: -1),
            ),
            range: range,
            colorArea: colorArea,
          ),
          size: const Size.square(200),
        ),
      );
    }

    testGoldens('PlotPainter - Polynomial', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Polynomial - low range',
          _buildPolynomialPainter(
            range: 2,
          ),
        )
        ..addScenario(
          'Polynomial - default',
          _buildPolynomialPainter(),
        )
        ..addScenario(
          'Polynomial - high range',
          _buildPolynomialPainter(
            range: 9,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 900),
      );

      await screenMatchesGolden(tester, 'polynomial_plot_painter');
    });

    testGoldens('PlotPainter - Nonlinear', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Nonlinear - low range',
          _buildNonlinearPainter(
            range: 2,
          ),
        )
        ..addScenario(
          'Nonlinear - default',
          _buildNonlinearPainter(),
        )
        ..addScenario(
          'Nonlinear - high range',
          _buildNonlinearPainter(
            range: 9,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 900),
      );

      await screenMatchesGolden(tester, 'nonlinear_plot_painter');
    });

    testGoldens('PlotPainter - Polynomial with area', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Polynomial - only color',
          _buildPolynomialPainter(
            colorArea: ColorArea(
              color: Colors.lightGreen.withAlpha(80),
              startPoint: -5,
              endPoint: 5,
            ),
          ),
        )
        ..addScenario(
          'Polynomial - color and ranges',
          _buildPolynomialPainter(
            colorArea: ColorArea(
              color: Colors.lightGreen.withAlpha(80),
              startPoint: -1,
              endPoint: 2,
            ),
          ),
        )
        ..addScenario(
          'Polynomial - color left range',
          _buildPolynomialPainter(
            colorArea: ColorArea(
              color: Colors.lightGreen.withAlpha(80),
              startPoint: -1,
              endPoint: 5,
            ),
          ),
        )
        ..addScenario(
          'Polynomial - color right range',
          _buildPolynomialPainter(
            colorArea: ColorArea(
              color: Colors.lightGreen.withAlpha(80),
              startPoint: -5,
              endPoint: 3.5,
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 1000),
      );

      await screenMatchesGolden(tester, 'polynomial_plot_painter_with_area');
    });
  });
}
