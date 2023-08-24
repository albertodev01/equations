import 'package:equations/equations.dart';

/// This class is extended by classes whose algorithms divide the integration
/// bounds into smaller intervals to compute the result. There currently are
/// three subclasses of `IntervalsIntegration`:
///
///  - [TrapezoidalRule]
///  - [SimpsonRule]
///  - [MidpointRule]
///
/// For a different approach that doesn't use [intervals], see
/// [AdaptiveQuadrature].
abstract base class IntervalsIntegration extends NumericalIntegration {
  /// The number of parts in which the interval `[lowerBound, upperBound]` has
  /// to be split by the algorithm.
  final int intervals;

  /// Creates a [IntervalsIntegration] object.
  const IntervalsIntegration({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    required this.intervals,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is IntervalsIntegration) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          lowerBound == other.lowerBound &&
          upperBound == other.upperBound &&
          intervals == other.intervals;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(function, lowerBound, upperBound, intervals);

  @override
  String toString() {
    final lower = lowerBound.toStringAsFixed(2);
    final upper = upperBound.toStringAsFixed(2);

    return '$function on [$lower, $upper]\nUsing $intervals intervals';
  }
}
