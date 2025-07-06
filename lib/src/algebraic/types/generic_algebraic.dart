part of '../algebraic.dart';

/// {@template generic_algebraic}
/// Concrete implementation of [Algebraic] that approximates all roots of a
/// polynomial of any degree.
///
/// For finding roots of a polynomial of degree 4 or lower, consider using
/// [Quartic], [Cubic], [Quadratic] or [Linear] instead, as they are more
/// efficient and numerically stable.
///
/// There is NO direct formula for finding the roots of a polynomial of degree
/// 5 or higher so this class returns a good approximation of the roots, but not
/// the exact ones.
///
/// An initial set of values [initialGuess] is required to find the roots but it
/// is optional. This implementation by default uses the Aberth method to
/// generate initial guesses if none are provided. If you are not sure which
/// initial values to provide, just leave [initialGuess] empty.
///
/// Note that this algorithm does **NOT** always converge. In other words, it is
/// **NOT** true that for every polynomial, the set of initial vectors that
/// eventually converges to roots is open and dense.
/// {@endtemplate}
///
/// {@template generic_algebraic_example}
/// These are examples of generic algebraic equations, where the coefficient
/// with the highest degree goes first:
///
/// ```dart
/// final genericAlgebraic = GenericAlgebraic(
///   coefficients: [
///     Complex.fromReal(-5),
///     Complex.fromReal(3),
///     Complex.i(),
///   ],
///   initialGuess: [
///     Complex(1, -2),
///     Complex.fromReal(3),
///   ],
/// );
/// ```
/// {@endtemplate}
final class GenericAlgebraic extends Algebraic with MathUtils {
  /// An initial set of values is required to find the roots but it is optional.
  ///
  /// This class by default uses the Aberth method to generate initial guesses
  /// if none are provided. If you are not sure which initial values to provide,
  /// just leave [initialGuess] empty.
  final List<Complex> initialGuess;

  /// The accuracy of the algorithm.
  final double precision;

  /// The maximum steps to be made by the algorithm.
  final int maxSteps;

  /// The minimum distance between initial guesses.
  final double minGuessDistance;

  /// The stagnation threshold for convergence.
  final double stagnationThreshold;

  /// {@macro generic_algebraic}
  ///
  /// {@macro generic_algebraic_example}
  ///
  /// If the coefficients of your polynomial contain only real numbers, consider
  /// using the [GenericAlgebraic.realEquation] constructor instead.
  GenericAlgebraic({
    required List<Complex> coefficients,
    this.initialGuess = const [],
    this.precision = 1.0e-10,
    this.maxSteps = 2000,
    this.minGuessDistance = 1.0e-6,
    this.stagnationThreshold = 1.0e-10,
  }) : super(coefficients);

  /// {@macro generic_algebraic}
  ///
  /// {@macro generic_algebraic_example}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [GenericAlgebraic.new] constructor instead.
  GenericAlgebraic.realEquation({
    required List<double> coefficients,
    this.initialGuess = const [],
    this.precision = 1.0e-10,
    this.maxSteps = 2000,
    this.minGuessDistance = 1.0e-6,
    this.stagnationThreshold = 1.0e-10,
  }) : super.realEquation(coefficients);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is GenericAlgebraic) {
      // Check all fields for equality
      if (coefficients.length != other.coefficients.length) {
        return false;
      }
      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] != other.coefficients[i]) {
          return false;
        }
      }

      // Compare initial guesses
      if (initialGuess.length != other.initialGuess.length) {
        return false;
      }
      for (var i = 0; i < initialGuess.length; ++i) {
        if (initialGuess[i] != other.initialGuess[i]) {
          return false;
        }
      }

      // Compare other fields
      return precision == other.precision &&
          maxSteps == other.maxSteps &&
          minGuessDistance == other.minGuessDistance &&
          stagnationThreshold == other.stagnationThreshold &&
          runtimeType == other.runtimeType;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(coefficients),
    Object.hashAll(initialGuess),
    precision,
    maxSteps,
    minGuessDistance,
    stagnationThreshold,
  );

  @override
  int get degree => coefficients.length - 1;

  @override
  Algebraic derivative() {
    // Rather than always returning 'GenericAlgebraic', if the degree is <= 4
    // there is the possibility to return a more convenient object
    switch (coefficients.length) {
      case 1:
        return Constant(a: coefficients.first).derivative();
      case 2:
        return Linear(a: coefficients.first, b: coefficients[1]).derivative();
      case 3:
        return Quadratic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
        ).derivative();
      case 4:
        return Cubic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
        ).derivative();
      case 5:
        return Quartic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
          e: coefficients[4],
        ).derivative();
      case 6:
        final coeffs = _derivativeOf();
        return Quartic(
          a: coeffs.first,
          b: coeffs[1],
          c: coeffs[2],
          d: coeffs[3],
          e: coeffs[4],
        );
      default:
        return GenericAlgebraic(
          coefficients: _derivativeOf(),
          precision: precision,
          maxSteps: maxSteps,
          minGuessDistance: minGuessDistance,
          stagnationThreshold: stagnationThreshold,
        );
    }
  }

  @override
  Complex discriminant() {
    // Say that P(x) is the polynomial represented by this instance and
    // P'(x) is the derivative of P. In order to calculate the discriminant of
    // a polynomial, we need to first compute the resultant Res(A, A') which
    // is equivalent to the determinant of the Sylvester matrix.
    final sylvester = SylvesterMatrix(polynomial: this);

    // Computes Res(A, A') and then determines the sign according with the
    // degree of the polynomial.
    return sylvester.polynomialDiscriminant();
  }

  @override
  List<Complex> solutions() {
    // In case the polynomial was a constant, just return an empty array because
    // there are no solutions.
    if (coefficients.length <= 1) {
      return const [];
    }

    // Make a copy of the coefficients and scale to make the polynomial monic
    final leadingCoeff = coefficients.first;
    if (leadingCoeff.abs() < precision) {
      throw const AlgebraicException(
        'Leading coefficient is too close to zero',
      );
    }

    // Scale all coefficients by dividing by the leading coefficient
    final scaledCoefficients =
        coefficients.map((c) => c / leadingCoeff).toList();
    final degree = (scaledCoefficients.length - 1).toDouble();

    // Initialize roots using Aberth's method if no initial guesses provided
    List<Complex> roots;

    if (initialGuess.isNotEmpty) {
      roots = List<Complex>.from(initialGuess);
    } else {
      // Calculate the center of the roots using the first two coefficients
      final center = -scaledCoefficients[1] / Complex.fromReal(degree);

      // Calculate the radius using the Aberth bound
      var radius = 0.0;
      for (var i = 1; i < scaledCoefficients.length; i++) {
        radius = max(radius, scaledCoefficients[i].abs() * (1.0 / i));
      }
      radius = 2 * radius; // Aberth's method typically uses a factor of 2

      // Generate initial guesses using Aberth's method
      roots = List<Complex>.generate(degree.floor(), (i) {
        // Calculate the angle with a small random perturbation
        final angle = 2 * pi * i / degree + (Random().nextDouble() - 0.5) * 0.1;

        // Calculate the radius with a small random perturbation
        final perturbedRadius =
            radius * (1 + (Random().nextDouble() - 0.5) * 0.1);

        // Generate the initial guess
        return center +
            Complex.fromReal(perturbedRadius) * Complex(cos(angle), sin(angle));
      });

      // Ensure minimum distance between initial guesses
      for (var i = 0; i < roots.length; i++) {
        for (var j = i + 1; j < roots.length; j++) {
          final distance = (roots[i] - roots[j]).abs();
          if (distance < minGuessDistance) {
            // Move the second root away from the first
            final direction =
                (roots[j] - roots[i]) / Complex.fromReal(distance);
            roots[j] =
                roots[i] + direction * Complex.fromReal(minGuessDistance);
          }
        }
      }
    }

    // Durand-Kerner iteration
    var converged = false;
    var iteration = 0;

    while (!converged && iteration < maxSteps) {
      converged = true;
      final newRoots = List<Complex>.from(roots);

      for (var i = 0; i < degree.floor(); i++) {
        // Evaluate polynomial at current root
        var p = scaledCoefficients[0];
        for (var j = 1; j < scaledCoefficients.length; j++) {
          p = p * roots[i] + scaledCoefficients[j];
        }

        // Evaluate denominator (product of differences)
        var denominator = const Complex.fromReal(1);
        for (var j = 0; j < degree.floor(); j++) {
          if (j != i) {
            denominator *= roots[i] - roots[j];
          }
        }

        // Update root using Durand-Kerner formula
        if (denominator.abs() > precision) {
          final correction = p / denominator;
          newRoots[i] = roots[i] - correction;

          // Check for convergence
          if (correction.abs() > precision) {
            converged = false;
          }
        }
      }

      roots = newRoots;
      iteration++;
    }

    // Sort roots by real part for stability
    roots.sort((a, b) => a.real.compareTo(b.real));

    return roots;
  }

  /// Returns the coefficients of the derivative of a given polynomial.
  List<Complex> _derivativeOf() {
    final newLength = coefficients.length - 1;

    // The derivative
    final result = List<Complex>.generate(
      newLength,
      (_) => const Complex.zero(),
      growable: false,
    );

    // Evaluation of the derivative
    for (var i = 0; i < newLength; ++i) {
      result[i] = coefficients[i] * Complex.fromReal((newLength - i) * 1.0);
    }

    return result;
  }

  /// {@macro algebraic_deep_copy}
  GenericAlgebraic copyWith({
    List<Complex>? coefficients,
    List<Complex>? initialGuess,
    double? precision,
    int? maxSteps,
    double? minGuessDistance,
    double? stagnationThreshold,
  }) => GenericAlgebraic(
    coefficients: coefficients ?? List<Complex>.from(this.coefficients),
    initialGuess: initialGuess ?? List<Complex>.from(this.initialGuess),
    precision: precision ?? this.precision,
    maxSteps: maxSteps ?? this.maxSteps,
    minGuessDistance: minGuessDistance ?? this.minGuessDistance,
    stagnationThreshold: stagnationThreshold ?? this.stagnationThreshold,
  );
}
