import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the state of a [Slider] in the [NonlinearDataInput] widget. This is
/// used to remember the precision of the root finding algorithm selected by the
/// user.
class PrecisionSliderCubit extends Cubit<double> {
  /// The minimum value.
  final double minValue;

  /// The maximum value.
  final double maxValue;

  /// The initial state is the average of [minValue] and [maxValue], so it's
  /// computed as `(minValue + maxValue) / 2`.
  PrecisionSliderCubit({
    required this.minValue,
    required this.maxValue,
  }) : super((minValue + maxValue) / 2);

  /// Updates the current slider value.
  void updateSlider(double newValue) {
    if ((newValue >= minValue) && (newValue <= maxValue)) {
      emit(newValue);
    }
  }

  /// Sets the state back to the initial value, which is the average of
  /// [minValue] and [maxValue].
  void reset() => emit((minValue + maxValue) / 2);
}
