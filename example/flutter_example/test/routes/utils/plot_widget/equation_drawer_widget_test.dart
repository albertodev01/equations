import 'package:equations/equations.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/utils/plot_widget/equation_drawer_widget.dart';
import 'package:equations_solver/routes/utils/plot_widget/function_evaluators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  late final Widget equationDrawerWidget;

  setUpAll(() {
    equationDrawerWidget = Center(
      child: SizedBox(
        width: 300,
        height: 400,
        child: EquationDrawerWidget(
          plotMode: PolynomialEvaluator(
            algebraic: Algebraic.fromReal([1, 2, -3, -2]),
          ),
        ),
      ),
    );
  });

  group("Testing the 'EquationDrawerWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: equationDrawerWidget,
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });

  group('Golden tests - EquationDrawerWidget', () {
    testWidgets('EquationDrawerWidget', (tester) async {
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
              child: EquationDrawerWidget(
                key: const Key('EquationDrawerWidget-Golden'),
                plotMode: PolynomialEvaluator(
                  algebraic: Algebraic.fromReal([1, 2, -3, -2]),
                ),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationDrawerWidget-Golden')),
        matchesGoldenFile('goldens/equation_drawer_widget.png'),
      );
    });

    testWidgets('EquationDrawerWidget - zoom', (tester) async {
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
              child: EquationDrawerWidget(
                key: const Key('EquationDrawerWidget-Golden'),
                plotMode: PolynomialEvaluator(
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
        find.byKey(const Key('EquationDrawerWidget-Golden')),
        matchesGoldenFile('goldens/equation_drawer_widget_zoom.png'),
      );
    });
  });
}
