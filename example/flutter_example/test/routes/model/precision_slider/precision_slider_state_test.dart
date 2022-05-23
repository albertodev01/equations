import 'package:equations_solver/routes/models/precision_slider/precision_slider_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PrecisionSliderState' class", () {
    test('Initial values', () {
      final precisionSlider = PrecisionSliderState(minValue: 1, maxValue: 5);

      expect(precisionSlider.minValue, equals(1));
      expect(precisionSlider.maxValue, equals(5));
    });

    test('Making sure that increase and decrease methods work correctly', () {
      var notifyCounter = 0;
      final precisionSlider = PrecisionSliderState(minValue: 1, maxValue: 5)
        ..addListener(() => ++notifyCounter);

      expect(notifyCounter, isZero);
      expect(precisionSlider.value, equals(3));

      // Increasing
      precisionSlider.updateSlider(4);
      expect(notifyCounter, equals(1));
      expect(precisionSlider.value, equals(4.0));

      // Increasing but out of bounds
      precisionSlider.updateSlider(100);
      expect(notifyCounter, equals(1));
      expect(precisionSlider.value, equals(4.0));

      // Reset
      precisionSlider.reset();

      expect(notifyCounter, equals(2));
      expect(precisionSlider.value, equals(3.0));
    });
  });
}
