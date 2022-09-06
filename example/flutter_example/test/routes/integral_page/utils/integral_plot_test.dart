import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:equations_solver/routes/integral_page/utils/integral_plot_widget.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'IntegralPlotWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        InheritedIntegral(
          integralState: IntegralState()
            ..solveIntegral(
              upperBound: '2',
              lowerBound: '1',
              function: 'x-2',
              intervals: 30,
              integralType: IntegralType.simpson,
            ),
          child: const MockWrapper(
            child: SingleChildScrollView(
              child: IntegralPlotWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(IntegralPlotWidget), findsOneWidget);
      expect(find.byType(CartesianPlane), findsOneWidget);
    });
  });

  group('Golden test - IntegralPlotWidget', () {
    Widget mockedTree({
      required IntegralState state,
    }) {
      return MockWrapper(
        child: InheritedIntegral(
          integralState: state,
          child: InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 1,
              maxValue: 10,
              initial: 5,
            ),
            child: const IntegralPlotWidget(),
          ),
        ),
      );
    }

    testWidgets('IntegralPlotWidget - simpson', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 800));

      await tester.pumpWidget(
        mockedTree(
          state: IntegralState()
            ..solveIntegral(
              upperBound: '2.5',
              lowerBound: '0',
              function: 'cos(x)*e^x',
              intervals: 30,
              integralType: IntegralType.simpson,
            ),
        ),
      );
      await expectLater(
        find.byType(IntegralPlotWidget),
        matchesGoldenFile('goldens/integral_plot_simpson.png'),
      );
    });

    testWidgets('IntegralPlotWidget - midpoint', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 800));

      await tester.pumpWidget(
        mockedTree(
          state: IntegralState()
            ..solveIntegral(
              upperBound: '0.75',
              lowerBound: '-1',
              function: 'x^3-2*x+1',
              intervals: 30,
              integralType: IntegralType.midPoint,
            ),
        ),
      );
      await expectLater(
        find.byType(IntegralPlotWidget),
        matchesGoldenFile('goldens/integral_plot_midpoint.png'),
      );
    });

    testWidgets('IntegralPlotWidget - trapezoid', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 800));

      await tester.pumpWidget(
        mockedTree(
          state: IntegralState()
            ..solveIntegral(
              upperBound: '3',
              lowerBound: '-3',
              function: 'x+2',
              intervals: 30,
              integralType: IntegralType.trapezoid,
            ),
        ),
      );
      await expectLater(
        find.byType(IntegralPlotWidget),
        matchesGoldenFile('goldens/integral_plot_trapezoid.png'),
      );
    });
  });
}
