part of '../algebraic.dart';

/// {@template generic_algebraic}
/// Concrete implementation of [Algebraic] that approximates all roots of a
/// polynomial of any degree using the Durand-Kerner (Weierstrass) method.
///
/// For polynomials of degree 4 or lower, consider using [Quartic], [Cubic],
/// [Quadratic] or [Linear] instead, as they compute the roots with closed-form
/// formulas.
///
/// By the Abel-Ruffini theorem, there is no general formula in radicals for
/// the roots of a polynomial of degree 5 or higher, so this class returns
/// numerical approximations of the roots.
///
/// The method needs one starting point per root. You can provide them with
/// [initialGuess], which must then contain exactly [degree] values. If
/// [initialGuess] is empty, the starting points are placed on a circle around
/// the centroid of the roots, as suggested by Aberth, whose radius is an upper
/// bound for the distance of the roots from the centroid. If you are not sure
/// which starting points to provide, leave [initialGuess] empty.
///
/// The method converges for almost all starting points in practice, but
/// convergence is not guaranteed in general. If the roots don't converge
/// within [maxSteps] iterations, the current approximations are returned.
/// {@endtemplate}
///
/// {@template generic_algebraic_example}
/// These are examples of generic algebraic equations, where the coefficient
/// with the highest degree goes first:
///
/// ```dart
/// // P(x) = x^5 - 3x^4 + 2x^2 - x + 7
/// final genericAlgebraic1 = GenericAlgebraic.realEquation(
///   coefficients: [1, -3, 0, 2, -1, 7],
/// );
///
/// // P(x) = (3 + 8i)x^6 - 2x^5 + (-1 + 5i)x^3 + 6x + i
/// final genericAlgebraic2 = GenericAlgebraic(
///   coefficients: [
///     Complex(3, 8),
///     Complex.fromReal(-2),
///     Complex.zero(),
///     Complex(-1, 5),
///     Complex.zero(),
///     Complex.fromReal(6),
///     Complex.i(),
///   ],
/// );
///
/// // P(x) = x^5 - 1, starting from custom initial guesses
/// final genericAlgebraic3 = GenericAlgebraic.realEquation(
///   coefficients: [1, 0, 0, 0, 0, -1],
///   initialGuess: [
///     Complex.fromReal(2),
///     Complex(1, 1),
///     Complex(-1, 1),
///     Complex(-1, -1),
///     Complex(1, -1),
///   ],
/// );
/// ```
/// {@endtemplate}
final class GenericAlgebraic extends Algebraic with MathUtils {
  /// {@macro generic_algebraic}
  ///
  /// {@macro generic_algebraic_example}
  ///
  /// If the coefficients of your polynomial contain only real numbers, consider
  /// using the [GenericAlgebraic.realEquation] constructor instead.
  new({
    required List<Complex> coefficients,
    this.initialGuess = const [],
    this.precision = 1.0e-10,
    this.maxSteps = 2000,
    this.minGuessDistance = 1.0e-6,
  }) : super(coefficients);

  /// {@macro generic_algebraic}
  ///
  /// {@macro generic_algebraic_example}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [GenericAlgebraic.new] constructor instead.
  new realEquation({
    required List<double> coefficients,
    this.initialGuess = const [],
    this.precision = 1.0e-10,
    this.maxSteps = 2000,
    this.minGuessDistance = 1.0e-6,
  }) : super.realEquation(coefficients);

  /// The starting points of the iteration, one per root.
  ///
  /// When this list is empty (the default), the starting points are generated
  /// automatically. Otherwise, it must contain exactly [degree] values or
  /// [solutions] throws an [AlgebraicException].
  final List<Complex> initialGuess;

  /// The relative tolerance used to stop the iteration.
  ///
  /// The iteration stops when, for every root `z`, the size of the last
  /// correction is at most `precision * max(1, |z|)`.
  final double precision;

  /// The maximum number of iterations.
  ///
  /// If the roots haven't converged after [maxSteps] iterations, [solutions]
  /// returns the current approximations.
  final int maxSteps;

  /// The minimum distance between the starting points. It must be positive.
  ///
  /// The generated starting points are placed at least this far apart. When
  /// two approximations coincide during the iteration (for example, because
  /// two equal values were given in [initialGuess]), one of them is moved by
  /// about this distance so that the iteration can continue.
  final double minGuessDistance;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is GenericAlgebraic) {
      if (coefficients.length != other.coefficients.length) {
        return false;
      }
      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] != other.coefficients[i]) {
          return false;
        }
      }

      if (initialGuess.length != other.initialGuess.length) {
        return false;
      }
      for (var i = 0; i < initialGuess.length; ++i) {
        if (initialGuess[i] != other.initialGuess[i]) {
          return false;
        }
      }

      return precision == other.precision &&
          maxSteps == other.maxSteps &&
          minGuessDistance == other.minGuessDistance;
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
  );

  @override
  int get degree => coefficients.length - 1;

  @override
  Algebraic derivative() {
    switch (coefficients.length) {
      case 1:
        return Constant(
          a: coefficients.first,
        ).derivative();
      case 2:
        return Linear(
          a: coefficients.first,
          b: coefficients[1],
        ).derivative();
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
        );
    }
  }

  @override
  Complex discriminant() {
    final sylvester = SylvesterMatrix(
      polynomial: this,
    );
    return sylvester.polynomialDiscriminant();
  }

  @override
  List<Complex> solutions() {
    if (coefficients.length <= 1) {
      return const [];
    }
    if (minGuessDistance <= 0) {
      throw const AlgebraicException('minGuessDistance must be positive.');
    }

    final n = degree;
    if (initialGuess.isNotEmpty && initialGuess.length != n) {
      throw AlgebraicException(
        'initialGuess must contain one value per root ($n in total), but it '
        'contains ${initialGuess.length}.',
      );
    }

    // The constructor guarantees that the leading coefficient is not zero.
    final leadingCoefficient = coefficients.first;

    var roots = initialGuess.isNotEmpty
        ? List<Complex>.of(initialGuess, growable: false)
        : _startingPoints(
            coefficients
                .map((c) => c / leadingCoefficient)
                .toList(growable: false),
          );

    // Durand-Kerner iteration:
    //
    //   z_i <- z_i - P(z_i) / (a_0 * prod_{j != i} (z_i - z_j))
    //
    // where a_0 is the leading coefficient.
    var converged = false;
    for (var step = 0; step < maxSteps && !converged; ++step) {
      converged = true;
      final newRoots = List<Complex>.of(roots, growable: false);

      for (var i = 0; i < n; ++i) {
        final z = roots[i];

        var denominator = const Complex.fromReal(1);
        for (var j = 0; j < n; ++j) {
          if (j != i) {
            denominator *= z - roots[j];
          }
        }

        if (denominator.isZero || !_isFinite(denominator)) {
          newRoots[i] =
              z +
              Complex.fromPolar(
                r: minGuessDistance * max(1.0, z.abs()),
                theta: i + 1.0,
              );
          converged = false;
          continue;
        }

        final correction = evaluateOn(z) / (leadingCoefficient * denominator);
        newRoots[i] = z - correction;

        if (correction.abs() > precision * max(1.0, z.abs())) {
          converged = false;
        }
      }

      roots = newRoots;
    }

    // Sort the roots so that the output order doesn't depend on the order of
    // the starting points.
    return roots.toList()..sort((a, b) {
      final byReal = a.real.compareTo(b.real);
      return byReal != 0 ? byReal : a.imaginary.compareTo(b.imaginary);
    });
  }

  /// Generates [degree] starting points for the Durand-Kerner iteration using
  /// the strategy suggested by Aberth.
  ///
  /// The points are equally spaced on a circle centered at the centroid of the
  /// roots, `-a_1 / n`, of the given [monic] polynomial. The radius is the
  /// Fujiwara bound of the polynomial shifted to the centroid, which is an
  /// upper bound for the distance of every root from the centroid.
  List<Complex> _startingPoints(List<Complex> monic) {
    final n = monic.length - 1;
    final center = -monic[1] / Complex.fromReal(n.toDouble());

    if (n == 1) {
      return [center];
    }

    // Coefficients of q(y) = p(y + center), by repeated synthetic division
    // (Taylor shift).
    final shifted = List<Complex>.of(monic, growable: false);
    for (var i = 0; i < n; ++i) {
      for (var j = 1; j <= n - i; ++j) {
        shifted[j] += center * shifted[j - 1];
      }
    }

    var bound = 0.0;
    for (var k = 1; k <= n; ++k) {
      final value = k == n ? shifted[k].abs() / 2 : shifted[k].abs();
      bound = max(bound, pow(value, 1 / k).toDouble());
    }
    final radius = max(2 * bound, minGuessDistance / (2 * sin(pi / n)));

    return List<Complex>.generate(n, (k) {
      final polar = Complex.fromPolar(
        r: radius,
        theta: 2 * pi * k / n + pi / (2 * n),
      );
      return center + polar;
    }, growable: false);
  }

  /// Returns `true` if both parts of [value] are finite.
  static bool _isFinite(Complex value) =>
      value.real.isFinite && value.imaginary.isFinite;

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
  }) => GenericAlgebraic(
    coefficients: coefficients ?? List<Complex>.from(this.coefficients),
    initialGuess: initialGuess ?? List<Complex>.from(this.initialGuess),
    precision: precision ?? this.precision,
    maxSteps: maxSteps ?? this.maxSteps,
    minGuessDistance: minGuessDistance ?? this.minGuessDistance,
  );
}
