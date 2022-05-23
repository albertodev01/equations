import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PlotZoomState' class", () {
    test('Initial values', () {
      final plotZoom = PlotZoomState(minValue: 1, maxValue: 5, initial: 3);

      expect(plotZoom.minValue, equals(1));
      expect(plotZoom.maxValue, equals(5));
      expect(plotZoom.initial, equals(3));
    });

    test('Making sure that increase and decrease methods work correctly', () {
      var notifyCounter = 0;
      final plotZoom = PlotZoomState(minValue: 1, maxValue: 5, initial: 3)
        ..addListener(() => ++notifyCounter);

      expect(notifyCounter, isZero);
      expect(plotZoom.zoom, equals(3));

      // Increasing
      plotZoom.updateSlider(4);
      expect(notifyCounter, equals(1));
      expect(plotZoom.zoom, equals(4.0));

      // Increasing but out of bounds
      plotZoom.updateSlider(100);
      expect(notifyCounter, equals(1));
      expect(plotZoom.zoom, equals(4.0));

      // Reset
      plotZoom.reset();

      expect(notifyCounter, equals(2));
      expect(plotZoom.zoom, equals(3.0));
    });
  });
}
