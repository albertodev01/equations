import 'package:collection/collection.dart';
import 'package:equations/equations.dart';

/// Abstract class representing an _algebraic equation_, also know as
/// _polynomial equation_, which has a single variable with a maximum degree.
///
/// The coefficients of the algebraic equations can be real numbers or complex
/// numbers. These are examples of an algebraic equations of third degree:
///
///   - x<sup>3</sup> + 5x + 2 = 0
///   - 2x<sup>3</sup> + (6+i)x + 8i = 0
///
/// This class stores the list of coefficients starting from the one with the
/// **highest** degree.
abstract class Algebraic {
  /// An unmodifiable list with the coefficients of the polynomial.
  late final List<Complex> coefficients;

  /// Creates a new algebraic equation by taking the coefficients of the
  /// polynomial starting from the one with the highest degree.
  ///
  /// For example, the equation `x^3 + 5x^2 + 3x - 2 = 0` would require a subclass
  /// of `Algebraic` to call the following...
  ///
  /// ```dart
  /// super([
  ///   Complex.fromReal(1), // x^3
  ///   Complex.fromReal(5), // x^2
  ///   Complex.fromReal(3), // x
  ///   Complex.fromReal(-2), // -2
  /// ]);
  /// ```
  ///
  /// ... because the coefficient with the highest degree goes first.
  ///
  /// If the coefficients of the polynomial are all real numbers, consider using
  /// the [Algebraic.realEquation(coefficients)] constructor which is more
  /// convenient.
  Algebraic(List<Complex> coefficients) {
    this.coefficients = UnmodifiableListView(List<Complex>.from(coefficients));

    // Unless this is a constant value, the coefficient with the highest degree
    // cannot be zero.
    if (!isValid) {
      throw AlgebraicException("The given equation is not valid.");
    }
  }

  /// Creates a new algebraic equation by taking the coefficients of the
  /// polynomial starting from the one with the highest degree.
  ///
  /// For example, the equation `x^3 + 5x^2 + 3x - 2 = 0` would require a subclass
  /// of `Algebraic` to call the following...
  ///
  /// ```dart
  /// super.realEquation(1, 5, 3, 2);
  /// ```
  ///
  /// ... because the coefficient with the highest degree goes first.
  ///
  /// Use this constructor when the coefficients are all real numbers. If there
  /// were complex numbers as well, use the [Algebraic(coefficients)] constructor.
  Algebraic.realEquation(List<double> coefficients) {
    this.coefficients = UnmodifiableListView(
        coefficients.map((value) => Complex.fromReal(value)).toList());

    // Unless this is a constant value, the coefficient with the highest degree
    // cannot be zero.
    if (!isValid) {
      throw AlgebraicException("The given equation is not valid.");
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is Algebraic) {
      // The lengths of the coefficients must match
      if (coefficients.length != other.coefficients.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
      var equalsCount = 0;

      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] == other.coefficients[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == coefficients.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < coefficients.length; ++i) {
      result = 37 * result + coefficients[i].hashCode;
    }

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
    if (coefficients.length == 1) {
      final value = coefficients[0];

      if (asFraction) {
        return "f(x) = ${value.toStringAsFraction()}";
      } else {
        return "f(x) = ${value.toStringWithParenthesis()}";
      }
    } else {
      final sb = StringBuffer();
      var power = coefficients.length - 1;

      // Adding 'f(x) = ' at the beginning
      sb.write("f(x) = ");

      for (final c in coefficients) {
        //1. If it's a coefficient 0, then skip
        if (c.isZero) {
          --power;
          continue;
        }

        // Write the sign unless it's the first coefficient
        if (power != coefficients.length - 1) {
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
    var power = coefficients.length - 1;

    // Actual valuation
    for (var c in coefficients) {
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
  bool get isRealEquation =>
      coefficients.every((value) => value.imaginary == 0);

  /// A polynomial equation is **valid** if the coefficient associated to the
  /// variable of highest degree is different from zero. In other words, the
  /// polynomial is valid if `a` is different from zero.
  ///
  /// A [Constant] is an exception because a constant value has no variables with
  /// a degree.
  bool get isValid => this is Constant ? true : !coefficients[0].isZero;

  /// Returns the coefficient of the polynomial at the given [index] position.
  /// For example:
  ///
  /// ```dart
  /// final quadratic = Quadratic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(-6),
  ///   c: Complex.fromReal(5),
  /// );
  ///
  /// final b = quadratic[1] // Complex(-6, 0)
  /// ```
  ///
  /// An exception is thrown if the index is out of the bounds.
  Complex operator [](int index) => coefficients[index];

  /// The discriminant of the algebraic equation if it exists.
  Complex discriminant();

  /// Calculates the roots (the solutions) of the equation.
  List<Complex> solutions();

  /// The derivative of the polynomial.
  Algebraic derivative();

  /// The degree of the polynomial.
  num get degree;
}
