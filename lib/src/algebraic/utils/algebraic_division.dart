import 'package:equations/equations.dart';

/// This utility class holds the quotient and the remainder of a division
/// between two polynomials. When you use `operator/` on two [Algebraic]
/// objects, this class is returned. For example:
///
/// ```dart
/// final numerator = Algebraic.fromReal([1, -3, 2]);
/// final denominator = Algebraic.fromReal([1, 2]);
///
/// final res = numerator / denominator; // 'res' is of type 'AlgebraicDivision'
/// ```
///
/// When dividing two polynomials, there always are a quotient and a remainder.
class AlgebraicDivision {
  /// The quotient of the division.
  final Algebraic quotient;

  /// The remainder of the divison.
  final Algebraic remainder;

  /// Creates an [AlgebraicDivision] with the given [quotient] and [remainder].
  const AlgebraicDivision({
    required this.quotient,
    required this.remainder,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is AlgebraicDivision) {
      return runtimeType == other.runtimeType &&
          quotient == other.quotient &&
          remainder == other.remainder;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(quotient, remainder);

  @override
  String toString() {
    final q = '$quotient'.replaceAll('f(x) = ', '');
    final r = '$remainder'.replaceAll('f(x) = ', '');

    return 'Q = $q\nR = $r';
  }
}
