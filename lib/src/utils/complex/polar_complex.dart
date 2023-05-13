import 'package:equations/equations.dart';

/// A wrapper class, returned by a [Complex] object, that represents a complex
/// number in polar coordinates.
final class PolarComplex implements Comparable<PolarComplex> {
  /// The absolute value/modulus of the complex number.
  final double r;

  /// The 'phi' angle expressed in radians.
  final double phiRadians;

  /// The 'phi' angle expressed in degrees.
  final double phiDegrees;

  /// The angle [r] is required both in radians ([phiRadians]) and degrees.
  /// ([phiDegrees]).
  const PolarComplex({
    required this.r,
    required this.phiRadians,
    required this.phiDegrees,
  });

  @override
  String toString() => 'r = $r\n'
      'phi (rad) = $phiRadians\n'
      'phi (deg) = $phiDegrees';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is PolarComplex) {
      return runtimeType == other.runtimeType &&
          r == other.r &&
          phiDegrees == other.phiDegrees &&
          phiRadians == other.phiRadians;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;

    result = result * 37 + r.hashCode;
    result = result * 37 + phiDegrees.hashCode;
    result = result * 37 + phiRadians.hashCode;

    return result;
  }

  @override
  int compareTo(PolarComplex other) {
    final thisValue = Complex.fromPolar(r: r, theta: phiRadians);
    final otherValue = Complex.fromPolar(r: other.r, theta: other.phiRadians);

    if (thisValue > otherValue) {
      return 1;
    }

    if (thisValue < otherValue) {
      return -1;
    }

    return 0;
  }

  /// {@macro algebraic_deep_copy}
  PolarComplex copyWith({
    double? r,
    double? phiRadians,
    double? phiDegrees,
  }) =>
      PolarComplex(
        r: r ?? this.r,
        phiDegrees: phiDegrees ?? this.phiDegrees,
        phiRadians: phiRadians ?? this.phiRadians,
      );
}
