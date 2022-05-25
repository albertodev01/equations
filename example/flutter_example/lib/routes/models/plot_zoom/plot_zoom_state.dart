import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:flutter/material.dart';

/// This listenable class handles the state of a material [Slider] widget. In
/// particular, it's used to keep track of the zoom of a [PlotWidget] widget.
class PlotZoomState extends ChangeNotifier {
  double _zoom = 0;

  /// The minimum zoom value.
  final double minValue;

  /// The maximum zoom value.
  final double maxValue;

  /// The initial value.
  final double initial;

  /// Creates a [PlotZoomState] object.
  PlotZoomState({
    required this.minValue,
    required this.maxValue,
    required this.initial,
  }) : _zoom = initial;

  /// The current state.
  double get zoom => _zoom;

  /// Updates the current position.
  void updateSlider(double newValue) {
    if ((newValue >= minValue) && (newValue <= maxValue)) {
      _zoom = newValue;
      notifyListeners();
    }
  }

  /// Sets the current state to [initial].
  void reset() {
    _zoom = initial;
    notifyListeners();
  }
}
