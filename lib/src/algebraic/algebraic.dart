import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/utils/math_utils.dart';

part 'types/constant.dart';
part 'types/cubic.dart';
part 'types/generic_algebraic.dart';
part 'types/linear.dart';
part 'types/quadratic.dart';
part 'types/quartic.dart';

/// The message thrown by the constructor to indicate that the polynomial cannot
/// be created correctly.
const _exceptionError = '''
To create a valid polynomial equation (except for constant values), the coefficient with the highest degree cannot be zero. Therefore, ensure that your list either:
 1. contains a single value (like `[5]` or `[-2]`) to represent a polynomial whose degree is zero (a constant value);
 2. contains one or more values AND the first parameter is not zero (for example, `[1, 0]` or `[-6, -3, 2, 8]`).
''';

/// A record type that holds the quotient and the remainder of a division
/// between two polynomials. When you use `operator/` on two [Algebraic]
/// objects, this type is returned. The quotient represents the result of the
/// division, while the remainder represents what's left after the division.
///
/// For example:
///
/// ```dart
/// final numerator = Algebraic.fromReal([1, -3, 2]);
/// final denominator = Algebraic.fromReal([1, 2]);
///
/// final res = numerator / denominator;
///
/// print(res.quotient); // Algebraic.fromReal([1, -5, 7])
/// print(res.remainder); // Algebraic.fromReal([-11, 24])
/// ```
typedef AlgebraicDivision = ({Algebraic quotient, Algebraic remainder});

/// {@template algebraic}
/// An abstract class that represents an _algebraic equation_, also known as
/// a _polynomial equation_, which has a single variable and a maximum degree.
///
/// The coefficients of the algebraic equations can be real numbers or complex
/// numbers. These are examples of algebraic equations of third degree:
///
/// • x³ + 5x + 2 = 0
/// • 2x³ + (6+i)x + 8i = 0
///
/// This class stores the coefficients list starting from the one with the
/// **highest** degree. For example, the equation `x³ + 5x² + 3x - 2 = 0`
/// would require a subclass of [Algebraic] to call the following:
///
/// ```dart
/// super([
///   Complex.fromReal(1), // x³
///   Complex.fromReal(5), // x²
///   Complex.fromReal(3), // x
///   Complex.fromReal(-2), // constant value
/// ]);
/// ```
///
/// The constructor throws an [AlgebraicException] if the first element of
/// [coefficients] is zero.
/// {@endtemplate}
sealed class Algebraic {
  /// The polynomial coefficients.
  final List<Complex> coefficients;

  /// {@macro algebraic}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, consider using [Algebraic.realEquation] for a less
  /// verbose syntax.
  Algebraic(this.coefficients) {
    // Unless this is a constant value, the coefficient with the highest degree
    // cannot be zero.
    if (!_isValid) {
      throw const AlgebraicException(_exceptionError);
    }
  }

  /// {@macro algebraic}
  ///
  /// If the coefficients of your polynomial contain complex numbers, use the
  /// [Algebraic.new] constructor instead.
  Algebraic.realEquation(List<double> coefficients)
    : this(
        coefficients.map(Complex.fromReal).toList(growable: false),
      );

  /// {@template algebraic_from}
  /// Creates an [Algebraic] object according to the length of [coefficients].
  /// In particular:
  ///
  ///  - if the length is 1, a [Constant] object is returned;
  ///  - if the length is 2, a [Linear] object is returned;
  ///  - if the length is 3, a [Quadratic] object is returned;
  ///  - if the length is 4, a [Cubic] object is returned;
  ///  - if the length is 5, a [Quartic] object is returned;
  ///  - if the length is 6 or higher, a [GenericAlgebraic] object is returned.
  ///
  /// For example:
  ///
  /// ```dart
  /// final linear = Algebraic.from(const [
  ///   Complex(1, 3),
  ///   Complex.i(),
  /// ]);
  /// ```
  ///
  /// In this case, `linear` is of type [Linear] because the given coefficients
  /// list represents the `(1 + 3i)x + i = 0` equation.
  /// {@endtemplate}
  ///
  /// Use this method when the coefficients can be complex numbers. If there
  /// are only real numbers, use the [Algebraic.fromReal] constructor which is
  /// more convenient.
  factory Algebraic.from(List<Complex> coefficients) {
    switch (coefficients.length) {
      case 1:
        return Constant(a: coefficients.first);
      case 2:
        return Linear(a: coefficients.first, b: coefficients[1]);
      case 3:
        return Quadratic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
        );
      case 4:
        return Cubic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
        );
      case 5:
        return Quartic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
          e: coefficients[4],
        );
      default:
        return GenericAlgebraic(
          coefficients: coefficients,
        );
    }
  }

  /// {@macro algebraic_from}
  ///
  /// Use this method when the coefficients are all real numbers. If there are
  /// complex numbers as well, use the [Algebraic.from] constructor instead.
  factory Algebraic.fromReal(List<double> coefficients) => Algebraic.from(
    coefficients.map(Complex.fromReal).toList(growable: false),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Algebraic) {
      if (coefficients.length != other.coefficients.length) {
        return false;
      }
      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] != other.coefficients[i]) {
          return false;
        }
      }

      return runtimeType == other.runtimeType;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hashAll(coefficients);

  @override
  String toString() => _convertToString();

  /// Returns a string representation of the polynomial where the coefficients
  /// are converted into their fractional representation.
  ///
  /// This method provides a more readable representation of polynomials with
  /// rational coefficients by converting decimal values to fractions where
  /// possible.
  String toStringWithFractions() => _convertToString(asFraction: true);

  /// Represents the equation as a string. If [asFraction] is `true` then
  /// the coefficients are converted into their fractional representation with
  /// the best approximation possible.
  String _convertToString({bool asFraction = false}) {
    if (coefficients.length == 1) {
      final value = coefficients.first;

      if (asFraction) {
        return 'f(x) = ${value.toStringAsFraction()}';
      } else {
        return 'f(x) = ${value.toStringWithParenthesis()}';
      }
    } else {
      final sb = StringBuffer();
      var power = coefficients.length - 1;

      // Adding 'f(x) = ' at the beginning
      sb.write('f(x) = ');

      for (final c in coefficients) {
        //1. If it's a coefficient 0, then skip
        if (c.isZero) {
          --power;
          continue;
        }

        // Write the sign unless it's the first coefficient
        if (power != coefficients.length - 1) {
          sb.write(' + ');
        }

        //2. Write the complex
        if (asFraction) {
          // Add parenthesis if needed
          if ((c.real != 0) && (c.imaginary != 0)) {
            sb
              ..write('(')
              ..write(c.toStringAsFraction())
              ..write(')');
          } else {
            sb.write(c.toStringAsFraction());
          }
        } else {
          sb.write(c.toStringWithParenthesis());
        }

        //3. If it is power = 0 avoid it, we don't want x^0 (useless)
        if (power != 0) {
          if (power == 1) {
            sb.write('x');
          } else {
            sb
              ..write('x^')
              ..write(power);
          }
        }

        --power;
      }

      return sb.toString();
    }
  }

  /// A polynomial equation is **valid** if the coefficient associated with the
  /// variable of highest degree is not zero. In other words, the polynomial is
  /// valid if the first coefficient in the list (which represents the highest
  /// degree term) is not zero.
  ///
  /// A [Constant] is a special case because a constant value has no variables
  /// with a degree.
  bool get _isValid {
    if (coefficients.isEmpty) {
      return false;
    }

    return this is Constant || !coefficients.first.isZero;
  }

  /// Evaluates the polynomial at the given complex value [x].
  ///
  /// This method computes P(x) where P is this polynomial and x is the given
  /// complex number. The evaluation is performed using Horner's method for
  /// numerical stability.
  ///
  /// Example:
  /// ```dart
  /// final poly = Quadratic.realEquation(a: 1, b: 2, c: 1); // x² + 2x + 1
  /// final result = poly.evaluateOn(Complex.fromReal(3));
  /// // result = Complex(16, 0) because 3² + 2(3) + 1 = 9 + 6 + 1 = 16
  /// ```
  Complex evaluateOn(Complex x) {
    var value = const Complex.zero();
    var power = coefficients.length - 1;

    // Actual valuation
    for (final c in coefficients) {
      if (power != 0) {
        value += x.pow(power) * c;
      } else {
        value += c;
      }
      power--;
    }

    return value;
  }

  /// Evaluates the polynomial at the given real value [x].
  ///
  /// This is a convenience method that converts the real number [x] to a
  /// complex number and calls [evaluateOn]. It's useful when you know you're
  /// working with real numbers and want to avoid the verbosity of creating
  /// [Complex] objects.
  ///
  /// Example:
  /// ```dart
  /// final poly = Linear.realEquation(a: 2, b: 3); // 2x + 3
  /// final result = poly.realEvaluateOn(5);
  /// // result = Complex(13, 0) because 2(5) + 3 = 13

  Complex realEvaluateOn(double x) => evaluateOn(Complex.fromReal(x));

  /// Evaluates the definite integral of the polynomial from [lower] to [upper].
  ///
  /// This method computes ∫[lower, upper] P(x)dx where P is this polynomial.
  /// The integral is computed analytically using the power rule for
  /// integration. For example:
  ///
  /// ```dart
  /// final poly = Linear.realEquation(a: 2, b: 3); // 2x + 3
  /// final integral = poly.evaluateIntegralOn(0, 2);
  /// // integral = Complex(10, 0) because ∫(2x+3)dx from 0 to 2 = 10
  /// ```
  ///
  /// The method works with both real and complex coefficients, returning
  /// complex results when necessary.
  Complex evaluateIntegralOn(double lower, double upper) {
    var upperSum = const Complex.zero();
    var lowerSum = const Complex.zero();

    // The actual integration
    for (var n = coefficients.length - 1; n >= 0; --n) {
      final coeff = coefficient(n) ?? const Complex.zero();
      final denominator = Complex.fromReal(n + 1);

      upperSum += coeff * Complex.fromReal(upper).pow(n + 1) / denominator;
      lowerSum += coeff * Complex.fromReal(lower).pow(n + 1) / denominator;
    }

    return upperSum - lowerSum;
  }

  /// Determines whether the polynomial is real or not.
  ///
  /// If at least one coefficient is complex, then the polynomial is complex.
  bool get isRealEquation => coefficients.every((c) => c.imaginary == 0);

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
  /// final a = quadratic[0] // a = Complex(2, 0)
  /// final b = quadratic[1] // b = Complex(-6, 0)
  /// final c = quadratic[2] // c = Complex(5, 0)
  /// ```
  ///
  /// An exception is thrown if the [index] is negative or if it doesn't
  /// correspond to a valid position.
  Complex operator [](int index) => coefficients[index];

  /// Returns the coefficient of the polynomial whose degree is [degree]. For
  /// example:
  ///
  /// ```dart
  /// final quadratic = Quadratic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(-6),
  ///   c: Complex.fromReal(5),
  /// );
  ///
  /// final degreeZero = quadratic.coefficient(0) // Complex(5, 0)
  /// final degreeOne = quadratic.coefficient(1) // Complex(-6, 0)
  /// final degreeTwo = quadratic.coefficient(2) // Complex(2, 0)
  /// ```
  ///
  /// This method returns `null` if no coefficient of the given [degree] is
  /// found.
  Complex? coefficient(int degree) {
    // The coefficient of the given degree doesn't exist
    if ((degree < 0) || (degree > coefficients.length - 1)) {
      return null;
    }

    // Return the coefficient of degree 'degree'
    return coefficients[coefficients.length - degree - 1];
  }

  /// The sum of two polynomials is performed by adding the corresponding
  /// coefficients.
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you can sum a [Cubic] with a [Linear].
  Algebraic operator +(Algebraic other) {
    final maxDegree = max<int>(coefficients.length, other.coefficients.length);
    final newCoefficients = <Complex>[];

    // The sum of two polynomials is the sum of the coefficients with the same
    // degree
    for (var degree = maxDegree; degree >= 0; --degree) {
      final thisCoefficient = coefficient(degree) ?? const Complex.zero();
      final otherCoefficient =
          other.coefficient(degree) ?? const Complex.zero();
      final sum = thisCoefficient + otherCoefficient;

      if (!sum.isZero) {
        newCoefficients.add(sum);
      }
    }

    // Returning a new instance
    return Algebraic.from(newCoefficients);
  }

  /// The difference of two polynomials is performed by subtracting the
  /// corresponding coefficients.
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you can subtract a [Quadratic] from a [Quartic].
  Algebraic operator -(Algebraic other) {
    final maxDegree = max<int>(coefficients.length, other.coefficients.length);
    final newCoefficients = <Complex>[];

    // The difference of two polynomials is the difference of the coefficients
    // with the same degree
    for (var degree = maxDegree; degree >= 0; --degree) {
      final thisCoefficient = coefficient(degree) ?? const Complex.zero();
      final otherCoefficient =
          other.coefficient(degree) ?? const Complex.zero();
      final diff = thisCoefficient - otherCoefficient;

      if (!diff.isZero) {
        newCoefficients.add(diff);
      }
    }

    // Returning a new instance
    return Algebraic.from(newCoefficients);
  }

  /// The product of two polynomials is performed by multiplying the
  /// corresponding coefficients of the polynomials.
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you can multiply a [Constant] with a [GenericAlgebraic].
  Algebraic operator *(Algebraic other) {
    // Generating the new list of coefficients
    final newLength = coefficients.length + other.coefficients.length - 1;
    final newCoefficients = List<Complex>.filled(
      newLength,
      const Complex.zero(),
    );

    // The product
    for (var i = 0; i < coefficients.length; ++i) {
      for (var j = 0; j < other.coefficients.length; ++j) {
        newCoefficients[i + j] += coefficients[i] * other.coefficients[j];
      }
    }

    // Returning a new instance
    return Algebraic.from(newCoefficients);
  }

  /// This operator divides a polynomial by another polynomial using the
  /// polynomial long division algorithm. The returned [AlgebraicDivision] type
  /// is a record type that contains both the quotient and the remainder of the
  /// division.
  ///
  /// The algorithm used to divide polynomials is implemented by the
  /// [PolynomialLongDivision] class.
  AlgebraicDivision operator /(Algebraic other) {
    final polyLongDivison = PolynomialLongDivision(
      polyNumerator: this,
      polyDenominator: other,
    );

    return polyLongDivison.divide();
  }

  /// The unary minus operator changes the sign of every coefficient of the
  /// polynomial. For example:
  ///
  /// ```dart
  /// final poly1 = Linear.realEquation(a: 3, b: -5);
  /// final poly2 = -poly1; // poly2 = Linear.realEquation(a: -3, b: 5);
  /// ```
  Algebraic operator -() =>
      Algebraic.from(coefficients.map((c) => -c).toList(growable: false));

  /// Factors the polynomial into irreducible factors.
  ///
  /// This method decomposes the polynomial into a product of irreducible
  /// factors. For example:
  ///
  /// ```dart
  /// final poly1 = Quadratic.realEquation(b: 0, c: -4); // x² - 4
  /// final factors1 = poly1.factor();
  /// // Returns [Linear(b: -2), Linear(b: 2)]
  /// // Which represents (x - 2)(x + 2)
  ///
  /// final poly2 = Quadratic.realEquation(b: 0, c: 4); // x² + 4
  /// final factors2 = poly2.factor();
  /// // Returns [Linear(b: -2i), Linear(b: 2i)]
  /// // Which represents (x - 2i)(x + 2i)
  /// ```
  ///
  /// Edge cases:
  ///
  /// - If the polynomial has no roots, returns a list containing only this
  ///   polynomial (indicating it is already irreducible)
  ///
  /// - If the polynomial is constant (degree 0), returns a list containing
  ///   only this polynomial
  ///
  /// - Repeated roots are handled correctly, with factors appearing multiple
  ///   times according to their multiplicity
  ///
  /// The factorization is not guaranteed to be unique, especially for
  /// polynomials with complex coefficients.
  List<Algebraic> factor() {
    final roots = solutions();

    // If the polynomial has no roots, it is already factored.
    if (roots.isEmpty) {
      return [this];
    }

    // Group roots by their value (to handle repeated roots)
    final rootGroups = <Complex, int>{};
    for (final root in roots) {
      rootGroups[root] = (rootGroups[root] ?? 0) + 1;
    }

    // Convert each root into a linear factor
    final factors = <Algebraic>[];
    for (final entry in rootGroups.entries) {
      final root = entry.key;
      final multiplicity = entry.value;

      // Create a linear factor (x - root)
      final factor = Linear(b: -root);

      // Add the factor as many times as its multiplicity
      for (var i = 0; i < multiplicity; i++) {
        factors.add(factor);
      }
    }

    return factors;
  }

  /// Solves the inequality associated with this polynomial.
  ///
  /// The inequality type is specified by the [inequalityType] parameter, which
  /// can be one of the following (where P(x) represents this polynomial):
  ///
  ///  - [AlgebraicInequalityType.lessThan]: solves P(x) < 0
  ///  - [AlgebraicInequalityType.lessThanOrEqualTo]: solves P(x) ≤ 0
  ///  - [AlgebraicInequalityType.greaterThan]: solves P(x) > 0
  ///  - [AlgebraicInequalityType.greaterThanOrEqualTo]: solves P(x) ≥ 0
  ///
  /// The [precision] parameter (defaults to 1e-10) is used to determine if a
  /// root is real or complex. If the imaginary part of a root is less than
  /// [precision], it is considered real. The precision must be a positive
  /// number.
  ///
  /// Returns a list of [AlgebraicInequalitySolution] objects representing the
  /// intervals where the inequality is satisfied.
  ///
  /// The returned list can be empty if the inequality is not satisfied for any
  /// real number.
  ///
  /// Throws an [AlgebraicException] if:
  ///  - The polynomial has complex coefficients
  ///  - The precision parameter is not positive
  List<AlgebraicInequalitySolution> solveInequality({
    required AlgebraicInequalityType inequalityType,
    double precision = 1e-10,
  }) {
    // First check the simpler validation
    if (precision <= 0) {
      throw const AlgebraicException(
        'The precision must be a positive number.',
      );
    }

    // Then check for complex coefficients
    if (!isRealEquation) {
      throw const AlgebraicException(
        'Inequalities are not well-defined in the complex plane.',
      );
    }

    // Get all roots of the polynomial
    final roots = solutions();

    // Filter out complex roots and convert to real numbers
    final realRoots = roots
        .where((root) => root.imaginary.abs() < precision)
        .map((root) => root.real)
        .toList();

    // If there are no real roots, check if the polynomial is always positive or
    // negative
    if (realRoots.isEmpty) {
      final testValue = realEvaluateOn(0);
      final isPositive = testValue.real > 0;
      final isSatisfied = switch (inequalityType) {
        AlgebraicInequalityType.lessThan => !isPositive,
        AlgebraicInequalityType.lessThanOrEqualTo => !isPositive,
        AlgebraicInequalityType.greaterThan => isPositive,
        AlgebraicInequalityType.greaterThanOrEqualTo => isPositive,
      };

      return isSatisfied ? [const AlgebraicInequalityAllRealNumbers()] : [];
    }

    // Sort roots in ascending order
    realRoots.sort((a, b) => a.compareTo(b));
    final inequalitySolutions = <AlgebraicInequalitySolution>[];

    // Test interval before first root
    final testBeforeFirst = realEvaluateOn(realRoots.first - 1.0);
    if (_isInequalitySatisfied(testBeforeFirst, inequalityType)) {
      inequalitySolutions.add(
        AlgebraicInequalitySmallerThan(
          value: realRoots.first,
          isInclusive:
              inequalityType == AlgebraicInequalityType.lessThanOrEqualTo,
        ),
      );
    }

    // Test intervals between consecutive roots
    for (var i = 0; i < realRoots.length - 1; i++) {
      final midPoint = (realRoots[i] + realRoots[i + 1]) / 2;
      final testValue = realEvaluateOn(midPoint);

      if (_isInequalitySatisfied(testValue, inequalityType)) {
        inequalitySolutions.add(
          AlgebraicInequalityInterval(
            start: realRoots[i],
            end: realRoots[i + 1],
            isInclusive:
                inequalityType == AlgebraicInequalityType.lessThanOrEqualTo ||
                inequalityType == AlgebraicInequalityType.greaterThanOrEqualTo,
          ),
        );
      }
    }

    // Test interval after last root
    final testAfterLast = realEvaluateOn(realRoots.last + 1.0);
    if (_isInequalitySatisfied(testAfterLast, inequalityType)) {
      inequalitySolutions.add(
        AlgebraicInequalityGreaterThan(
          value: realRoots.last,
          isInclusive:
              inequalityType == AlgebraicInequalityType.greaterThanOrEqualTo,
        ),
      );
    }

    return inequalitySolutions;
  }

  /// Helper method to check if a value satisfies the inequality
  bool _isInequalitySatisfied(Complex value, AlgebraicInequalityType type) =>
      switch (type) {
        AlgebraicInequalityType.lessThan => value.real < 0,
        AlgebraicInequalityType.lessThanOrEqualTo => value.real <= 0,
        AlgebraicInequalityType.greaterThan => value.real > 0,
        AlgebraicInequalityType.greaterThanOrEqualTo => value.real >= 0,
      };

  /// The polynomial discriminant, if it exists.
  ///
  /// The discriminant is a mathematical expression that provides information
  /// about the nature of the roots of a polynomial equation. The discriminant
  /// is well-defined for polynomials up to degree 4. For higher-degrees, it is
  /// approximated with a numerical method.
  Complex discriminant();

  /// Finds the roots (the solutions) of the associated _P(x) = 0_ equation.
  List<Complex> solutions();

  /// The derivative of the polynomial.
  Algebraic derivative();

  /// The degree of the polynomial.
  num get degree;
}
