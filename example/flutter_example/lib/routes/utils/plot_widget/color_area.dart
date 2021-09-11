import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/material.dart';

/// Used in [PlotterPainter] to color a portion of area below the function.
class ColorArea {
  /// The [Color] of the area below the function.
  ///
  /// By default, this is set to [Colors.transparent].
  final Color color;

  /// The point on the `x` axis from which starting to color the area.
  final double startPoint;

  /// The point on the `x` axis where the area to color ends.
  final double endPoint;

  /// Creates a [ColorArea] class to give instructions to a [PlotterPainter]
  /// about coloring the area below a function.
  const ColorArea({
    required this.startPoint,
    required this.endPoint,
    this.color = Colors.transparent,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is ColorArea) {
      return runtimeType == other.runtimeType &&
          color == other.color &&
          startPoint == other.startPoint &&
          endPoint == other.endPoint;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    result = result * 37 + color.hashCode;
    result = result * 37 + startPoint.hashCode;
    result = result * 37 + endPoint.hashCode;

    return result;
  }

  @override
  String toString() {
    final start = startPoint.toStringAsFixed(2);
    final end = endPoint.toStringAsFixed(2);

    return '$color from $start to $end';
  }
}
