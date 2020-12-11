import 'package:equations/equations.dart';

/// Object returned by a [Complex] which represents the number in polar
/// coordinates.
class PolarComplex implements Comparable<PolarComplex> {
  /// The absolute value/modulus of the complex number.
  final double r;

  /// The angle phi expressed in radians.
  final double phiRadians;

  /// The angle phi expressed in degrees.
  final double phiDegrees;

  /// The angle [r] is required both in radians ([phiRadians]) and degrees.
  /// ([phiDegrees]).
  const PolarComplex(
      {required this.r, required this.phiRadians, required this.phiDegrees});

  @override
  String toString() => "r = $r\n"
      "phi (rad) = $phiRadians\n"
      "phi (deg) = $phiDegrees";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

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
    result = 37 * result + r.hashCode;
    result = 37 * result + phiDegrees.hashCode;
    result = 37 * result + phiRadians.hashCode;
    return result;
  }

  @override
  int compareTo(PolarComplex other) {
    final thisValue = Complex.fromPolar(r, phiRadians);
    final otherValue = Complex.fromPolar(other.r, other.phiRadians);

    if (thisValue > otherValue) return 1;
    if (thisValue < otherValue) return -1;
    return 0;
  }

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
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
