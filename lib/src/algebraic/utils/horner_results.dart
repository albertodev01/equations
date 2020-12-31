import 'package:equations/equations.dart';

/// Utility class internally used by [Laguerre] to hold the results of horner
/// polynomial evaluation.
class HornerResult {
  /// The list of evaluated coefficients.
  final List<Complex> polynomial;

  /// The "distance" from the desired root.
  final Complex value;

  /// Requires list of newly evaluated coefficients ([polynomial]) and the
  /// estimated "distance" from the root ([value]).
  const HornerResult(this.polynomial, this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is HornerResult) {
      // The lengths of the coefficients must match
      if (polynomial.length != other.polynomial.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
      var equalsCount = 0;

      for (var i = 0; i < polynomial.length; ++i) {
        if (polynomial[i] == other.polynomial[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == polynomial.length &&
          value == other.value;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < polynomial.length; ++i) {
      result = 37 * result + polynomial[i].hashCode;
    }

    // The missing fields
    result = 37 * result + value.hashCode;

    return result;
  }
}
