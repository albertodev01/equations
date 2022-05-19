import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/utils/polynomial_plot.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PolynomialPlotWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        InheritedPolynomial(
          polynomialState: PolynomialState(PolynomialType.linear)
            ..solvePolynomial(['1', '2']),
          child: const MockWrapper(
            child: PolynomialPlotWidget(),
          ),
        ),
      );

      expect(find.byType(PolynomialPlotWidget), findsOneWidget);
      expect(find.byType(PlotIcon), findsOneWidget);
    });
  });

  group('Golden test - PolynomialPlotWidget', () {
    Widget mockedTree({
      required PolynomialState state,
    }) {
      return MockWrapper(
        child: InheritedPolynomial(
          polynomialState: state,
          child: InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 1,
              maxValue: 10,
              initial: 5,
            ),
            child: const PolynomialPlotWidget(),
          ),
        ),
      );
    }

    testWidgets('PolynomialPlotWidget - linear equation', (tester) async {
      await tester.pumpWidget(
        mockedTree(
          state: PolynomialState(PolynomialType.linear)
            ..solvePolynomial(const ['1', '2']),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_plot_linear.png'),
      );
    });

    testWidgets('PolynomialPlotWidget - quadratic equation', (tester) async {
      await tester.pumpWidget(
        mockedTree(
          state: PolynomialState(PolynomialType.quadratic)
            ..solvePolynomial(const ['-2', '-1/4', '3']),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_plot_quadratic.png'),
      );
    });

    testWidgets('PolynomialPlotWidget - cubic equation', (tester) async {
      await tester.pumpWidget(
        mockedTree(
          state: PolynomialState(PolynomialType.cubic)
            ..solvePolynomial(const ['1', '-2', '-1/4', '3']),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_plot_cubic.png'),
      );
    });

    testWidgets('PolynomialPlotWidget - quartic equation', (tester) async {
      await tester.pumpWidget(
        mockedTree(
          state: PolynomialState(PolynomialType.quartic)
            ..solvePolynomial(const ['-1', '0', '3', '0', '-1']),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_plot_quartic.png'),
      );
    });
  });
}
