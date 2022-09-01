import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/nonlinear_plot_widget.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'NonlinearPlotWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        InheritedNonlinear(
          nonlinearState: NonlinearState(NonlinearType.singlePoint)
            ..solveWithSinglePoint(
              initialGuess: 'x0',
              function: 'x-2',
              precision: 1.0e-10,
              method: SinglePointMethods.newton,
            ),
          child: const MockWrapper(
            child: SingleChildScrollView(
              child: NonlinearPlotWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(NonlinearPlotWidget), findsOneWidget);
      expect(find.byType(PlotIcon), findsOneWidget);
    });
  });

  group('Golden test - NonlinearPlotWidget', () {
    Widget mockedTree({
      required NonlinearState state,
    }) {
      return MockWrapper(
        child: InheritedNonlinear(
          nonlinearState: state,
          child: InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 1,
              maxValue: 10,
              initial: 5,
            ),
            child: const NonlinearPlotWidget(),
          ),
        ),
      );
    }

    testWidgets('NonlinearPlotWidget - single point', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 900));

      await tester.pumpWidget(
        mockedTree(
          state: NonlinearState(NonlinearType.singlePoint)
            ..solveWithSinglePoint(
              initialGuess: '-3',
              function: 'e^x-sin(x)',
              precision: 1.0e-10,
              method: SinglePointMethods.newton,
            ),
        ),
      );
      await expectLater(
        find.byType(NonlinearPlotWidget),
        matchesGoldenFile('goldens/nonlinear_plot_single_point.png'),
      );
    });

    testWidgets('NonlinearPlotWidget - bracketing', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 900));

      await tester.pumpWidget(
        mockedTree(
          state: NonlinearState(NonlinearType.bracketing)
            ..solveWithBracketing(
              lowerBound: '0.25',
              upperBound: '1.46',
              function: 'x^5-e^x',
              precision: 1.0e-10,
              method: BracketingMethods.bisection,
            ),
        ),
      );
      await expectLater(
        find.byType(NonlinearPlotWidget),
        matchesGoldenFile('goldens/nonlinear_plot_bisection.png'),
      );
    });
  });
}
