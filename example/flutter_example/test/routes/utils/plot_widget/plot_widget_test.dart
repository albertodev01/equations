import 'package:equations/equations.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  late final Widget plotWidget;

  setUpAll(() {
    plotWidget = Center(
      child: SizedBox(
        width: 300,
        height: 400,
        child: PlotWidget(
          plotMode: PolynomialPlot(
            algebraic: Algebraic.fromReal([1, 2, -3, -2]),
          ),
        ),
      ),
    );
  });

  group("Testing the 'PlotWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: plotWidget,
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });

  group('Golden tests - PlotWidget', () {
    testWidgets('PlotWidget', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 1,
              maxValue: 10,
              initial: 4,
            ),
            child: SizedBox(
              width: 500,
              height: 580,
              child: PlotWidget(
                key: const Key('PlotWidget-Golden'),
                plotMode: PolynomialPlot(
                  algebraic: Algebraic.fromReal([1, 2, -3, -2]),
                ),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_widget.png'),
      );
    });

    testWidgets('PlotWidget - zoom', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 1,
              maxValue: 10,
              initial: 4,
            ),
            child: SizedBox(
              width: 500,
              height: 580,
              child: PlotWidget(
                key: const Key('PlotWidget-Golden'),
                plotMode: PolynomialPlot(
                  algebraic: Algebraic.fromReal([1, 2, -3, -2]),
                ),
              ),
            ),
          ),
        ),
      );

      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(80, 0));
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const Key('PlotWidget-Golden')),
        matchesGoldenFile('goldens/plot_widget_zoom.png'),
      );
    });
  });
}
