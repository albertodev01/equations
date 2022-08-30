import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/plot_widget/color_area.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  Widget buildPolynomialPainter({
    int range = 5,
    ColorArea colorArea = const ColorArea(
      startPoint: 5,
      endPoint: 5,
    ),
    List<double> coefficients = const [1, 2, -3, -2],
  }) {
    return MockWrapper(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: CustomPaint(
            key: const Key('PlotWidget-Golden'),
            painter: PlotterPainter(
              plotMode: PolynomialPlot(
                algebraic: Algebraic.fromReal(coefficients),
              ),
              range: range,
              colorArea: colorArea,
            ),
            size: const Size.square(200),
          ),
        ),
      ),
    );
  }

  Widget buildNonlinearPainter({
    int range = 5,
    ColorArea colorArea = const ColorArea(
      startPoint: 5,
      endPoint: 5,
    ),
  }) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: CustomPaint(
        key: const Key('PlotWidget-Golden'),
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

  group('Golden tests - PlotPainter (no area)', () {
    testWidgets('Polynomial - low range', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          range: 2,
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_polynomial_low.png'),
      );
    });

    testWidgets('Polynomial - default', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_polynomial.png'),
      );
    });

    testWidgets('Polynomial - high range', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          range: 9,
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_polynomial_high.png'),
      );
    });

    testWidgets('Polynomial - with edges', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(coefficients: [1, 0]),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_polynomial_edges.png'),
      );
    });

    testWidgets('Nonlinear - low range', (tester) async {
      await tester.pumpWidget(
        buildNonlinearPainter(
          range: 2,
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_nonlinear_low.png'),
      );
    });

    testWidgets('Nonlinear - default', (tester) async {
      await tester.pumpWidget(
        buildNonlinearPainter(),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_nonlinear.png'),
      );
    });

    testWidgets('Nonlinear - high range', (tester) async {
      await tester.pumpWidget(
        buildNonlinearPainter(
          range: 9,
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_nonlinear_high.png'),
      );
    });
  });

  group('Golden tests - PlotPainter (with area)', () {
    testWidgets('Color only', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: ColorArea(
            color: Colors.lightGreen.withAlpha(80),
            startPoint: -5,
            endPoint: 5,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_area_color.png'),
      );
    });

    testWidgets('Color and ranges', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: ColorArea(
            color: Colors.lightGreen.withAlpha(80),
            startPoint: -1,
            endPoint: 2,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_area_color_and_ranges.png'),
      );
    });

    testWidgets('Color and ranges swapped', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: ColorArea(
            color: Colors.lightGreen.withAlpha(80),
            startPoint: 2,
            endPoint: -1,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile(
          'goldens/plot_painter_area_color_and_ranges_swapped.png',
        ),
      );
    });

    testWidgets('Color and left range only', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: ColorArea(
            color: Colors.lightGreen.withAlpha(80),
            startPoint: -1,
            endPoint: 5,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_area_color_left_range.png'),
      );
    });

    testWidgets('Color and right range only', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: ColorArea(
            color: Colors.lime.withAlpha(80),
            startPoint: -5,
            endPoint: 3.5,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_painter_area_color_right_range.png'),
      );
    });
  });
}
