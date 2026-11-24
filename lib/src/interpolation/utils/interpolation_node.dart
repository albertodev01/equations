import 'package:equations/equations.dart';

/// {@template interpolation_node}
/// A point in the Cartesian coordinate system used by [Interpolation] types to
/// represent interpolation nodes. This class simply represents the `x` and `y`
/// coordinates of a point on a Cartesian plane.
/// {@endtemplate}
final class InterpolationNode {
  /// {@macro interpolation_node}
  const new({
    required this.x,
    required this.y,
  });

  /// The x coordinate.
  final double x;

  /// The y coordinate.
  final double y;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is InterpolationNode) {
      return runtimeType == other.runtimeType && x == other.x && y == other.y;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x; $y)';

  /// Prints the [x] and [y] values of this [InterpolationNode] instance with
  /// [fractionDigits] decimal digits. Each coordinate is formatted the same way
  /// as calling `toStringAsFixed` on a [double]. For example:
  ///
  /// ```dart
  /// const example = InterpolationNode(
  ///   x: 5.123,
  ///   y: 8.123,
  /// );
  ///
  /// // Calling 'toStringAsFixed' on the `InterpolationNode` object
  /// print(example.toStringAsFixed(1)); // (5.1, 8.1)
  ///
  /// // The same result but with 'toStringAsFixed' calls on 'x' and 'y' values
  /// final x = example.x.toStringAsFixed(1);
  /// final y = example.y.toStringAsFixed(1);
  ///
  /// print('($x, $y)'); // (5.1, 8.1)
  /// ```
  String toStringAsFixed(int fractionDigits) {
    final xValue = x.toStringAsFixed(fractionDigits);
    final yValue = y.toStringAsFixed(fractionDigits);

    return '($xValue, $yValue)';
  }
}
