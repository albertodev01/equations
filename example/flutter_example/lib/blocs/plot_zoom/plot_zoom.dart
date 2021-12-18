import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the state of a material [Slider] widget. In particular,
/// [PlotZoomCubit] is used to keep track of the zoom of a [PlotWidget] widget.
class PlotZoomCubit extends Cubit<double> {
  /// The minimum zoom value.
  final double minValue;

  /// The maximum zoom value.
  final double maxValue;

  /// The initial value.
  final double initial;

  /// Creates a [Cubit] that keeps track of the state of a [PlotWidget] widget.
  PlotZoomCubit({
    required this.minValue,
    required this.maxValue,
    required this.initial,
  }) : super(initial);

  /// Updates the current position.
  void updateSlider(double newValue) {
    if ((newValue >= minValue) && (newValue <= maxValue)) {
      emit(newValue);
    }
  }

  /// Sets the current state to [initial].
  void reset() => emit(initial);
}
