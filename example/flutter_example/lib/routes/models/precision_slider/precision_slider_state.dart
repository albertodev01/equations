import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:flutter/material.dart';

/// Holds the state of a [Slider] in the [NonlinearDataInput] widget. This is
/// used to remember the precision of the root finding algorithm selected by the
/// user.
class PrecisionSliderState extends ChangeNotifier {
  double _value = 0;

  /// The minimum value.
  final double minValue;

  /// The maximum value.
  final double maxValue;

  /// The initial state is the average of [minValue] and [maxValue], so it's
  /// computed as `(minValue + maxValue) / 2`.
  PrecisionSliderState({
    required this.minValue,
    required this.maxValue,
  }) : _value = (minValue + maxValue) / 2;

  /// The current state.
  double get value => _value;

  /// Updates the current slider value.
  void updateSlider(double newValue) {
    if ((newValue >= minValue) && (newValue <= maxValue)) {
      _value = newValue;
      notifyListeners();
    }
  }

  /// Sets the state back to the initial value, which is the average of
  /// [minValue] and [maxValue].
  void reset() {
    _value = (minValue + maxValue) / 2;
    notifyListeners();
  }
}
