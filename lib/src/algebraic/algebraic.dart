import 'package:collection/collection.dart';
import 'package:equations/src/algebraic/constant.dart';
import 'package:equations/src/common/exceptions.dart';

import '../complex.dart';

/// Abstract class that represents an _algebraic equation_, also know as
/// _polynomial equation_, which has a single variable with a maximum degree.
///
/// The coefficients of the algebraic equations can be real numbers or complex
/// numbers. These are examples of an algebraic equations of third degree:
///
///   - x<sup>3</sup> + 5x + 2 = 0
///   - 2x<sup>3</sup> + (6+i)x + 8i = 0
///
/// This class stores the list of coefficients starting from the one with the
/// *highest* degree.
abstract class Algebraic {
  final List<Complex> _coefficients;

  /// Creates a new algebraic equation by taking the coefficients of the
  /// polynomial starting from the one with the highest degree.
  ///
  /// For example, the equation `x^3 + 5x^2 + 3x - 2 = 0` would require a subclass
  /// of `Algebraic` to call the following:
  ///
  /// ```dart
  /// super(1, 5, 3, 2);
  /// ```
  Algebraic(List<Complex> coefficients) : _coefficients = coefficients {
    if (!isValid) {
      throw AlgebraicException("The given equation is not valid.");
    }
  }

  @override
  bool operator ==(Object other) {
    final compare = const DeepCollectionEquality().equals;

    return identical(this, other) ||
        other is Algebraic &&
            runtimeType == other.runtimeType &&
            compare(_coefficients, other._coefficients);
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + _coefficients.hashCode;
    return result;
  }

  @override
  String toString() => _convertToString();

  /// Returns a string representation of the polynomial where the coefficients
  /// are converted into their fractional representation.
  String toStringWithFractions() => _convertToString(asFraction: true);

  /// Represents the equation as a string. If [asFraction] is `true` then
  /// the coefficients are converted into their fractional representation with
  /// the best approximation possible.
  String _convertToString({bool asFraction = false}) {
    if (_coefficients.length == 1) {
      final value = _coefficients[0];

      if (asFraction) {
        return "f(x) = ${value.toStringAsFraction()}";
      } else {
        return "f(x) = ${value.toStringWithParenthesis()}";
      }
    } else {
      final sb = StringBuffer();
      var power = _coefficients.length - 1;

      // Adding 'f(x) = ' at the beginning
      sb.write("f(x) = ");

      for (final c in _coefficients) {
        //1. If it's a coefficient 0, then skip
        if (c.isZero) {
          --power;
          continue;
        }

        // Write the sign unless it's the first coefficient
        if (power != _coefficients.length - 1) {
          sb.write(" + ");
        }

        //2. Write the complex
        if (asFraction) {
          // Add parenthesis if needed
          if ((c.real != 0) && (c.imaginary != 0)) {
            sb..write("(")..write(c.toStringAsFraction())..write(")");
          } else {
            sb.write(c.toStringAsFraction());
          }
        } else {
          sb.write(c.toStringWithParenthesis());
        }

        //3. If it is power = 0 avoid it, we don't want x^0 (useless)
        if (power != 0) {
          if (power == 1) {
            sb.write("x");
          } else {
            sb..write("x^")..write(power);
          }
        }

        --power;
      }

      return sb.toString();
    }
  }

  /// Evaluates the polynomial on the specified complex number [x].
  Complex evaluateOn(Complex x) {
    var value = Complex.zero();
    var power = _coefficients.length - 1;

    for (var c in _coefficients) {
      if (power != 0) {
        value += (x.pow(power) * c);
      } else {
        value += c;
      }

      power--;
    }

    return value;
  }

  /// Evaluates the polynomial on the specified real number [x].
  Complex realEvaluateOn(double x) => evaluateOn(Complex.fromReal(x));

  /// Determines whether the polynomial is real or not.
  ///
  /// If at least one coefficient is complex, then the polynomial is complex.
  bool get isRealEquation => _coefficients.any((coeff) => coeff.imaginary == 0);

  /// A polynomial equation is *valid* if the coefficient associated to the
  /// variable of highest degree is different from zero. In other words, the
  /// polynomial is valid if `a` is different from zero.
  ///
  /// A [Constant] is an exception because a constant value has no variables with
  /// a degree.
  bool get isValid => this is Constant ? true : !_coefficients[0].isZero;

  /// An unmodifiable list with the coefficients of the polynomial.
  List<Complex> get coefficients => List.unmodifiable(_coefficients);

  /// The discriminant of the algebraic equation if it exists.
  Complex discriminant();

  /// Calculates the roots (the solutions) of the equation.
  List<Complex> solutions();

  /// The derivative of the polynomial
  Algebraic derivative();

  /// The degree of the polynomial
  num get degree;
}
