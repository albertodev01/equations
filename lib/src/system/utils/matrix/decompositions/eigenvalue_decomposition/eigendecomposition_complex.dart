import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigen_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// {@macro eigendecomposition_class_header}
///
/// This class performs the eigendecomposition on [ComplexMatrix] types. `D`
/// is always a diagonal matrix, whose elements are the (complex) eigenvalues,
/// and the i-th column of `V` is the unit eigenvector of the i-th eigenvalue.
///
/// The implementation uses different algorithms depending on the matrix type:
///
///  - **Hermitian matrices** (`A = A^H`): the Jacobi eigenvalue algorithm.
///    The eigenvalues are real and sorted in ascending order, `V` is unitary
///    and `V^-1` is computed exactly as `V^H`.
///  - **Other matrices**: Householder reduction to Hessenberg form, followed
///    by the shifted QR algorithm to get the complex Schur form `T`. The
///    eigenvectors are computed by back substitution on `T`.
///
/// Example:
/// ```dart
/// final matrix = ComplexMatrix.fromData(
///   rows: 2,
///   columns: 2,
///   data: [
///     [Complex(1, 0), Complex(0, 1)],
///     [Complex(0, -1), Complex(1, 0)],
///   ],
/// );
/// final decomposition = EigendecompositionComplex(matrix: matrix);
/// final [V, D, VInv] = decomposition.decompose();
/// ```
final class EigendecompositionComplex
    extends EigenDecomposition<Complex, ComplexMatrix>
    with MathUtils {
  /// {@macro eigendecomposition_class_header}
  const new({required super.matrix});

  /// The machine epsilon of [double].
  static const _epsilon = 2.220446049250313e-16;

  /// The largest acceptable error (relative to the elements of the matrix
  /// and to its size) of `V x D x V^-1`. It's the square root of [_epsilon]:
  /// larger errors mean that the matrix is (numerically) defective.
  static const _defectiveTolerance = 1.4901161193847656e-8;

  /// Thrown when the matrix doesn't have a basis of eigenvectors.
  static const _notDiagonalizableError = MatrixException(
    'The matrix is not diagonalizable: its eigenvectors are not linearly '
    'independent.',
  );

  /// The maximum number of sweeps of the Jacobi algorithm.
  static const _maxSweeps = 100;

  /// The maximum number of QR iterations for each eigenvalue.
  static const _maxIterations = 100;

  /// Every this many QR iterations without convergence, an exceptional shift
  /// is used to break possible cycles.
  static const _exceptionalShiftInterval = 10;

  @override
  List<ComplexMatrix> decompose() {
    if (!matrix.isSquareMatrix) {
      throw const MatrixException('The matrix must be square.');
    }

    if (matrix.flattenData.any(
      (value) => !value.real.isFinite || !value.imaginary.isFinite,
    )) {
      throw const MatrixException(
        'The eigendecomposition cannot be computed on matrices with NaN or '
        'infinite values.',
      );
    }

    // Scaling the data so that the largest element has magnitude 1, which
    // avoids overflows and underflows in the intermediate computations. The
    // eigenvectors don't change while the eigenvalues are scaled back later.
    final n = matrix.rowCount;
    final scale = matrix.flattenData.fold<double>(
      0,
      (current, value) => max(current, _magnitude(value)),
    );

    if (scale == 0) {
      // The zero matrix: every vector is an eigenvector of the eigenvalue 0.
      final identity = ComplexMatrix(rows: n, columns: n, identity: true);

      return [identity, ComplexMatrix(rows: n, columns: n), identity];
    }

    final scaled = matrix
        .toListOfList()
        .map((row) => row.map((value) => _divide(value, scale)).toList())
        .toList();

    // The algorithms work in place on 'scaled', so a copy is kept to verify
    // the result.
    final scaledMatrix = ComplexMatrix.fromData(
      rows: n,
      columns: n,
      data: scaled,
    );

    final [V, D, inverseV] = _isHermitian()
        ? _hermitianDecomposition(scaled)
        : _schurDecomposition(scaled);

    // A nearly defective matrix can have a V that is invertible in floating
    // point arithmetic, but so ill-conditioned that V x D x V^-1 is far from
    // the original matrix. The elements of the scaled matrix are at most 1.
    final reconstructed = V * D * inverseV;
    final difference = reconstructed - scaledMatrix;
    final residual = difference.flattenData.fold<double>(
      0,
      (m, value) => max(m, max(value.real.abs(), value.imaginary.abs())),
    );
    if (!(residual <= n * _defectiveTolerance)) {
      throw _notDiagonalizableError;
    }

    return [
      V,
      _diagonal(
        List<Complex>.generate(
          n,
          (i) => Complex(D(i, i).real * scale, D(i, i).imaginary * scale),
        ),
      ),
      inverseV,
    ];
  }

  /// The magnitude of [value], computed without overflows or underflows.
  double _magnitude(Complex value) => hypot(value.real, value.imaginary);

  /// Divides both parts of [value] by the real number [divisor].
  static Complex _divide(Complex value, double divisor) =>
      Complex(value.real / divisor, value.imaginary / divisor);

  /// Returns `true` if the matrix is equal to its conjugate transpose. This
  /// implies that the diagonal is real.
  bool _isHermitian() {
    final n = matrix.rowCount;

    for (var i = 0; i < n; i++) {
      for (var j = i; j < n; j++) {
        if (matrix(i, j) != matrix(j, i).conjugate()) {
          return false;
        }
      }
    }

    return true;
  }

  /// Computes the eigendecomposition of a Hermitian matrix with the cyclic
  /// Jacobi algorithm: unitary rotations are applied to zero the off-diagonal
  /// elements one at a time, until the matrix is diagonal.
  List<ComplexMatrix> _hermitianDecomposition(List<List<Complex>> a) {
    final n = a.length;
    final v = _identity(n);

    // Off-diagonal elements below this threshold are considered zero. The
    // Frobenius norm doesn't change with unitary rotations.
    final frobeniusNorm = a.fold<double>(
      0,
      (norm, row) =>
          row.fold<double>(norm, (value, x) => hypot(value, x.abs())),
    );
    final threshold = _epsilon * frobeniusNorm;

    var converged = false;
    for (var sweep = 0; sweep < _maxSweeps && !converged; sweep++) {
      converged = true;

      for (var p = 0; p < n - 1; p++) {
        for (var q = p + 1; q < n; q++) {
          final apq = a[p][q];
          final absApq = apq.abs();
          if (absApq <= threshold) {
            continue;
          }

          converged = false;

          // The rotation J, in the (p, q) plane, has columns (c, -s conj(e))
          // and (s e, c) where e is the phase of a(p, q). With 't' being the
          // smallest root of t^2 + 2 zeta t - 1 = 0, J^H A J has zeros in the
          // (p, q) and (q, p) positions.
          final zeta = (a[q][q].real - a[p][p].real) / (2 * absApq);
          final t = (zeta >= 0 ? 1 : -1) / (zeta.abs() + hypot(1, zeta));
          final c = 1 / sqrt(1 + t * t);
          final s = c * t;
          final phase = apq * Complex.fromReal(1 / absApq);

          final cc = Complex.fromReal(c);
          final sPhase = Complex.fromReal(s) * phase;
          final sConjugatePhase = Complex.fromReal(s) * phase.conjugate();

          // A x J (columns p and q) and V x J
          for (var k = 0; k < n; k++) {
            final akp = a[k][p];
            final akq = a[k][q];
            a[k][p] = cc * akp - sConjugatePhase * akq;
            a[k][q] = sPhase * akp + cc * akq;

            final vkp = v[k][p];
            final vkq = v[k][q];
            v[k][p] = cc * vkp - sConjugatePhase * vkq;
            v[k][q] = sPhase * vkp + cc * vkq;
          }

          // J^H x A (rows p and q)
          for (var k = 0; k < n; k++) {
            final apk = a[p][k];
            final aqk = a[q][k];
            a[p][k] = cc * apk - sPhase * aqk;
            a[q][k] = sConjugatePhase * apk + cc * aqk;
          }

          // These values are known exactly.
          a[p][q] = const Complex.zero();
          a[q][p] = const Complex.zero();
          a[p][p] = Complex.fromReal(a[p][p].real);
          a[q][q] = Complex.fromReal(a[q][q].real);
        }
      }
    }

    if (!converged) {
      throw const MatrixException(
        'The eigendecomposition algorithm did not converge.',
      );
    }

    // Sorting the (real) eigenvalues in ascending order.
    final order = List<int>.generate(n, (i) => i)
      ..sort((x, y) => a[x][x].real.compareTo(a[y][y].real));

    final V = ComplexMatrix.fromFlattenedData(
      rows: n,
      columns: n,
      data: List<Complex>.generate(n * n, (k) => v[k ~/ n][order[k % n]]),
    );

    // V is unitary, so its inverse is the conjugate transpose.
    final inverseV = ComplexMatrix.fromFlattenedData(
      rows: n,
      columns: n,
      data: List<Complex>.generate(n * n, (k) => V(k % n, k ~/ n).conjugate()),
    );

    return [V, _diagonal(order.map((i) => a[i][i]).toList()), inverseV];
  }

  /// Computes the eigendecomposition of a generic square matrix. The matrix
  /// is reduced to the upper triangular Schur form `T = Z^H A Z`, whose
  /// diagonal contains the eigenvalues. The eigenvectors of `T` are computed
  /// by back substitution and then mapped back with `Z`.
  List<ComplexMatrix> _schurDecomposition(List<List<Complex>> t) {
    final n = t.length;
    final z = _identity(n);

    _reduceToHessenberg(t, z);
    _reduceToSchurForm(t, z);

    // Small denominators in the back substitution (which happen with
    // repeated eigenvalues) are replaced by this value.
    final norm = t.fold<double>(
      0,
      (current, row) =>
          row.fold<double>(current, (value, x) => max(value, x.abs())),
    );
    final smallPivot = max<double>(norm, 1) * _epsilon;

    final eigenvectors = List<List<Complex>>.generate(n, (k) {
      // Solving (T - lambda I) y = 0 with y(k) = 1 and y(j) = 0 for j > k.
      final lambda = t[k][k];
      final y = List<Complex>.filled(k + 1, const Complex.zero());
      y[k] = const Complex.fromReal(1);

      for (var j = k - 1; j >= 0; j--) {
        var sum = const Complex.zero();
        for (var i = j + 1; i <= k; i++) {
          sum += t[j][i] * y[i];
        }

        var denominator = t[j][j] - lambda;
        if (denominator.abs() < smallPivot) {
          denominator = Complex.fromReal(smallPivot);
        }
        y[j] = -sum / denominator;

        // Rescaling to avoid overflows when the values grow too much.
        final largest = y.fold<double>(0, (m, value) => max(m, value.abs()));
        if (largest > 1e100) {
          final factor = Complex.fromReal(1 / largest);
          for (var i = j; i <= k; i++) {
            y[i] *= factor;
          }
        }
      }

      // x = Z y, normalized to have unit 2-norm.
      final x = List<Complex>.generate(n, (row) {
        var sum = const Complex.zero();
        for (var i = 0; i <= k; i++) {
          sum += z[row][i] * y[i];
        }

        return sum;
      });

      final xNorm = x.fold<double>(0, (m, value) => hypot(m, value.abs()));
      final factor = Complex.fromReal(1 / xNorm);

      return x.map((value) => value * factor).toList();
    });

    final V = ComplexMatrix.fromFlattenedData(
      rows: n,
      columns: n,
      data: List<Complex>.generate(n * n, (k) => eigenvectors[k % n][k ~/ n]),
    );

    // When the matrix is defective (it doesn't have n linearly independent
    // eigenvectors), V is singular and the decomposition doesn't exist.
    final ComplexMatrix inverseV;
    try {
      inverseV = V.inverse();
    } on MatrixException {
      throw _notDiagonalizableError;
    }

    return [V, _diagonal(List<Complex>.generate(n, (i) => t[i][i])), inverseV];
  }

  /// Reduces [h] to upper Hessenberg form (zeros below the first subdiagonal)
  /// using Householder reflections `P = I - 2 v v^H`. The transformations are
  /// accumulated in [z], so that the original matrix is `Z H Z^H`.
  void _reduceToHessenberg(List<List<Complex>> h, List<List<Complex>> z) {
    final n = h.length;

    for (var k = 0; k < n - 2; k++) {
      var norm = 0.0;
      for (var i = k + 1; i < n; i++) {
        norm = hypot(norm, h[i][k].abs());
      }

      if (norm == 0) {
        continue;
      }

      // The reflection maps the column to (-alpha, 0, ..., 0), where alpha has
      // the same phase of the first element to avoid cancellation.
      final first = h[k + 1][k];
      final firstAbs = first.abs();
      final alpha = firstAbs == 0
          ? Complex.fromReal(norm)
          : first * Complex.fromReal(norm / firstAbs);

      final v = List<Complex>.generate(
        n - k - 1,
        (i) => i == 0 ? first + alpha : h[k + 1 + i][k],
      );
      final vNorm = v.fold<double>(0, (m, value) => hypot(m, value.abs()));
      final inverseNorm = Complex.fromReal(1 / vNorm);
      for (var i = 0; i < v.length; i++) {
        v[i] *= inverseNorm;
      }

      // P x H (rows k+1 and below)
      for (var col = k + 1; col < n; col++) {
        var dot = const Complex.zero();
        for (var i = 0; i < v.length; i++) {
          dot += v[i].conjugate() * h[k + 1 + i][col];
        }
        final factor = dot * const Complex.fromReal(2);
        for (var i = 0; i < v.length; i++) {
          h[k + 1 + i][col] -= factor * v[i];
        }
      }

      // H x P and Z x P (columns k+1 and after)
      for (final target in [h, z]) {
        for (var row = 0; row < n; row++) {
          var dot = const Complex.zero();
          for (var i = 0; i < v.length; i++) {
            dot += target[row][k + 1 + i] * v[i];
          }
          final factor = dot * const Complex.fromReal(2);
          for (var i = 0; i < v.length; i++) {
            target[row][k + 1 + i] -= factor * v[i].conjugate();
          }
        }
      }

      // The reflected column is known exactly.
      h[k + 1][k] = -alpha;
      for (var i = k + 2; i < n; i++) {
        h[i][k] = const Complex.zero();
      }
    }
  }

  /// Reduces the Hessenberg matrix [h] to upper triangular form (the complex
  /// Schur form) with the shifted QR algorithm. The unitary transformations
  /// are accumulated in [z].
  ///
  /// Throws a [MatrixException] if the algorithm doesn't converge.
  void _reduceToSchurForm(List<List<Complex>> h, List<List<Complex>> z) {
    final n = h.length;
    final norm = h.fold<double>(
      0,
      (current, row) =>
          row.fold<double>(current, (value, x) => hypot(value, x.abs())),
    );

    var hi = n - 1;
    var iterations = 0;

    while (hi > 0) {
      // Looking for a negligible subdiagonal element, from the bottom.
      var lo = hi;
      while (lo > 0) {
        var scale = h[lo - 1][lo - 1].abs() + h[lo][lo].abs();
        if (scale == 0) {
          scale = norm;
        }

        if (h[lo][lo - 1].abs() <= _epsilon * scale) {
          h[lo][lo - 1] = const Complex.zero();
          break;
        }

        lo--;
      }

      // The last eigenvalue of the active block has converged.
      if (lo == hi) {
        hi--;
        iterations = 0;
        continue;
      }

      if (++iterations > _maxIterations) {
        throw const MatrixException(
          'The eigendecomposition algorithm did not converge.',
        );
      }

      final shift = _computeShift(h, hi, iterations);

      // One QR step on the active block: H - shift I = Q R, then H = R Q +
      // shift I. The Givens rotations are applied to the whole rows and
      // columns, so that h converges to the full Schur form.
      for (var k = lo; k <= hi; k++) {
        h[k][k] -= shift;
      }

      final cosines = List<double>.filled(hi - lo, 0);
      final sines = List<Complex>.filled(hi - lo, const Complex.zero());

      for (var k = lo; k < hi; k++) {
        final (c, s) = _givens(h[k][k], h[k + 1][k]);
        cosines[k - lo] = c;
        sines[k - lo] = s;

        // G^H x H, where G^H = | c        s |
        //                      | -conj(s) c |
        final cc = Complex.fromReal(c);
        final minusConjugateS = -s.conjugate();
        for (var col = k; col < n; col++) {
          final x = h[k][col];
          final y = h[k + 1][col];
          h[k][col] = cc * x + s * y;
          h[k + 1][col] = minusConjugateS * x + cc * y;
        }
      }

      for (var k = lo; k < hi; k++) {
        final cc = Complex.fromReal(cosines[k - lo]);
        final s = sines[k - lo];
        final conjugateS = s.conjugate();

        // H x G and Z x G, where G = | c        -s |
        //                            | conj(s)  c  |
        for (var row = 0; row <= k + 1; row++) {
          final x = h[row][k];
          final y = h[row][k + 1];
          h[row][k] = cc * x + conjugateS * y;
          h[row][k + 1] = -s * x + cc * y;
        }

        for (var row = 0; row < n; row++) {
          final x = z[row][k];
          final y = z[row][k + 1];
          z[row][k] = cc * x + conjugateS * y;
          z[row][k + 1] = -s * x + cc * y;
        }
      }

      for (var k = lo; k <= hi; k++) {
        h[k][k] += shift;
      }
    }

    // The elements below the diagonal are zero (up to rounding errors).
    for (var i = 1; i < n; i++) {
      for (var j = 0; j < i; j++) {
        h[i][j] = const Complex.zero();
      }
    }
  }

  /// Computes the shift of the QR step for the active block ending at row
  /// [hi]. This is the Wilkinson shift (the eigenvalue of the trailing 2x2
  /// block closer to the last diagonal element), except every few
  /// [iterations], when an exceptional shift is used instead.
  Complex _computeShift(List<List<Complex>> h, int hi, int iterations) {
    final a = h[hi - 1][hi - 1];
    final b = h[hi - 1][hi];
    final c = h[hi][hi - 1];
    final d = h[hi][hi];

    if (iterations % _exceptionalShiftInterval == 0) {
      return d + Complex.fromReal(0.75 * c.abs());
    }

    // The eigenvalues of the 2x2 block are d + half +/- root. The one closer
    // to d is computed as d - bc / (half +/- root), choosing the sign that
    // gives the largest denominator to avoid cancellation.
    final half = (a - d) * const Complex.fromReal(0.5);
    final root = (half * half + b * c).sqrt();
    final plus = half + root;
    final minus = half - root;
    final denominator = plus.abs() >= minus.abs() ? plus : minus;

    if (denominator == const Complex.zero()) {
      return d;
    }

    return d - (b * c) / denominator;
  }

  /// Computes the Givens rotation `(c, s)`, with `c` real, such that:
  ///
  /// ```txt
  /// | c        s | | a |   | r |
  /// | -conj(s) c | | b | = | 0 |
  /// ```
  (double, Complex) _givens(Complex a, Complex b) {
    final absA = a.abs();
    final absB = b.abs();
    final rho = hypot(absA, absB);

    if (rho == 0) {
      return (1, const Complex.zero());
    }

    if (absA == 0) {
      return (0, b.conjugate() * Complex.fromReal(1 / absB));
    }

    return (
      absA / rho,
      a * b.conjugate() * Complex.fromReal(1 / (absA * rho)),
    );
  }

  /// The `n x n` identity matrix, as a list of rows.
  static List<List<Complex>> _identity(int n) => List<List<Complex>>.generate(
    n,
    (i) => List<Complex>.generate(
      n,
      (j) => i == j ? const Complex.fromReal(1) : const Complex.zero(),
    ),
  );

  /// The diagonal matrix with the given [values] on the diagonal.
  ///
  /// The diagonal values are the eigenvalues.
  static ComplexMatrix _diagonal(List<Complex> values) {
    final n = values.length;

    return ComplexMatrix.fromFlattenedData(
      rows: n,
      columns: n,
      data: List<Complex>.generate(
        n * n,
        (k) => k ~/ n == k % n ? values[k ~/ n] : const Complex.zero(),
      ),
    );
  }
}
