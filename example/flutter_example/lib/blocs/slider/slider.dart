import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the state of a material [Slider] widget. In particular,
/// [SliderCubit] stores the currently selected value of the slider.
class SliderCubit extends Cubit<double> {
  /// The minimum value of the slider.
  final double minValue;

  /// The maximum value of the slider.
  final double maxValue;

  /// The initial value of the slider.
  final double initial;

  /// Creates a [Cubit] that keeps track of the state of a slider widget.
  SliderCubit({
    required this.minValue,
    required this.maxValue,
    required this.initial,
  }) : super(initial);

  /// Updates the current slider position.
  void updateSlider(double newValue) {
    if ((newValue >= minValue) && (newValue <= maxValue)) {
      emit(newValue);
    }
  }

  /// Resets the slider setting the current state to [initial].
  void reset() => emit(initial);
}
