import 'package:equation_painter/src/equation_painter_widget.dart';
import 'package:flutter/material.dart';

/// Manages the state of a the [Slider] underneath [EquationPainterWidget].
class PainterZoomState extends ChangeNotifier {
  double _zoom = 0;

  /// The minimum zoom value.
  final double minValue;

  /// The maximum zoom value.
  final double maxValue;

  /// The initial value.
  final double initial;

  /// Creates a [PainterZoomState] object.
  PainterZoomState({
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
