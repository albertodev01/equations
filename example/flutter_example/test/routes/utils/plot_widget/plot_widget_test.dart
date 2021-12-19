import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

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
      await tester.pumpWidget(MockWrapper(
        child: plotWidget,
      ));

      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testGoldens('PlotWidget', (tester) async {
      final widget = SizedBox(
        width: 500,
        height: 580,
        child: BlocProvider<PlotZoomCubit>(
          create: (_) => PlotZoomCubit(
            minValue: 1,
            maxValue: 10,
            initial: 4,
          ),
          child: PlotWidget(
            plotMode: PolynomialPlot(
              algebraic: Algebraic.fromReal([1, 2, -3, -2]),
            ),
          ),
        ),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(500, 650),
      );
      await screenMatchesGolden(tester, 'plotwidget');
    });

    testGoldens('PlotWidget - zoom', (tester) async {
      final widget = SizedBox(
        width: 500,
        height: 580,
        child: BlocProvider<PlotZoomCubit>(
          create: (_) => PlotZoomCubit(
            minValue: 1,
            maxValue: 10,
            initial: 4,
          ),
          child: PlotWidget(
            plotMode: PolynomialPlot(
              algebraic: Algebraic.fromReal([1, 2, -3, -2]),
            ),
          ),
        ),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(500, 650),
      );

      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(80, 0));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'plotwidget_zoom');
    });
  });
}
