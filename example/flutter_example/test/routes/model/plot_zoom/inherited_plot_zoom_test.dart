import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedPlotZoom' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final plotZoom = PlotZoomState(
        minValue: 1,
        maxValue: 5,
        initial: 3,
      );

      final inheritedNavigation = InheritedPlotZoom(
        plotZoomState: plotZoom,
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNavigation.updateShouldNotify(inheritedNavigation),
        isFalse,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 1,
              maxValue: 5,
              initial: 3,
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 2,
              maxValue: 5,
              initial: 2,
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
    });

    testWidgets(
      "Making sure that the static 'of' method doesn't throw when located up "
      'in the tree',
      (tester) async {
        late PlotZoomState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedPlotZoom(
              plotZoomState: PlotZoomState(
                minValue: 1,
                maxValue: 5,
                initial: 3,
              ),
              child: Builder(
                builder: (context) {
                  reference = InheritedPlotZoom.of(context).plotZoomState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.minValue, equals(1));
        expect(reference.maxValue, equals(5));
        expect(reference.initial, equals(3));
      },
    );
  });
}
