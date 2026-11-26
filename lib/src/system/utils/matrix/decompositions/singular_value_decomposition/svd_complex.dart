import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/single_value_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// {@macro svd_class_header}
///
/// This class performs the SVD procedure on [ComplexMatrix] types. Since the
/// data is complex, the relation is `A = U x E x V^H` (where `V^H` is the
/// conjugate transpose of `V`), `U` and `V` are unitary and the singular
/// values on the diagonal of `E` are real and non-negative.
///
/// The implementation uses the one-sided Jacobi algorithm, which computes
/// the singular values with high relative accuracy.
///
/// Example:
/// ```dart
/// final matrix = ComplexMatrix.fromData(
///   rows: 2,
///   columns: 3,
///   data: [
///     [Complex(1, 0), Complex(2, 1), Complex(3, -1)],
///     [Complex(4, 1), Complex(5, 0), Complex(6, 2)],
///   ],
/// );
/// final decomposition = SVDComplex(matrix: matrix);
/// final [E, U, V] = decomposition.decompose();
/// ```
final class SVDComplex
    extends SingleValueDecomposition<Complex, ComplexMatrix> {
  /// {@macro svd_class_header}
  const new({required super.matrix});

  /// The machine epsilon of [double].
  static const _epsilon = 2.220446049250313e-16;

  /// The maximum number of Jacobi sweeps. Convergence is quadratic, so a few
  /// sweeps are normally enough.
  static const _maxSweeps = 100;

  @override
  List<ComplexMatrix> decompose() {
    if (matrix.flattenData.any(
      (value) => !value.real.isFinite || !value.imaginary.isFinite,
    )) {
      throw const MatrixException(
        'The SVD cannot be computed on matrices with NaN or infinite values.',
      );
    }

    // The algorithm requires at least as many rows as columns. For a wide
    // matrix, the SVD of the conjugate transpose is computed instead:
    //
    //  A^H = U' x E' x V'^H, so A = V' x E'^T x U'^H
    //
    // because the singular values in E' are real.
    if (matrix.rowCount < matrix.columnCount) {
      final [e, u, v] = SVDComplex(
        matrix: _conjugateTranspose(matrix),
      ).decompose();

      return [e.transpose(), v, u];
    }

    final m = matrix.rowCount;
    final n = matrix.columnCount;

    // Scaling the data so that the largest element has magnitude 1, which
    // avoids overflows and underflows when squaring the column norms.
    final scale = matrix.flattenData.fold<double>(
      0,
      (current, value) => max(current, hypot(value.real, value.imaginary)),
    );

    if (scale == 0) {
      return [
        ComplexMatrix(rows: m, columns: n),
        ComplexMatrix(rows: m, columns: m, identity: true),
        ComplexMatrix(rows: n, columns: n, identity: true),
      ];
    }

    // The columns of W = A x V (stored column by column) and of V. At the end,
    // the columns of W are mutually orthogonal.
    final w = List<List<Complex>>.generate(n, (j) {
      return List<Complex>.generate(m, (i) {
        final value = matrix(i, j);

        return Complex(value.real / scale, value.imaginary / scale);
      });
    });
    final v = List<List<Complex>>.generate(
      n,
      (j) => List<Complex>.generate(
        n,
        (i) => i == j ? const Complex.fromReal(1) : const Complex.zero(),
      ),
    );

    _orthogonalizeColumns(w, v, tolerance: m * _epsilon);

    // The singular values are the norms of the columns of W, sorted from the
    // largest to the smallest.
    final norms = w.map(_norm).toList(growable: false);
    final order = List<int>.generate(n, (j) => j)
      ..sort((a, b) => norms[b].compareTo(norms[a]));
    final singularValues = order.map((j) => norms[j]).toList(growable: false);

    // The columns of U matching (numerically) non-zero singular values are the
    // normalized columns of W. The others are completed to an orthonormal
    // basis of the whole space.
    final threshold = singularValues.first * max(m, n) * _epsilon;
    final columnsU = List<List<Complex>?>.generate(m, (j) {
      if (j >= n || singularValues[j] <= threshold) {
        return null;
      }

      final factor = Complex.fromReal(1 / singularValues[j]);
      return w[order[j]].map((value) => value * factor).toList();
    });
    _completeBasis(columnsU, m);

    final scaleFactor = Complex.fromReal(scale);
    final E = List<Complex>.generate(m * n, (k) {
      final i = k ~/ n;
      final j = k % n;

      return i == j
          ? Complex.fromReal(singularValues[i]) * scaleFactor
          : const Complex.zero();
    });

    return [
      ComplexMatrix.fromFlattenedData(rows: m, columns: n, data: E),
      ComplexMatrix.fromFlattenedData(
        rows: m,
        columns: m,
        data: List<Complex>.generate(m * m, (k) => columnsU[k % m]![k ~/ m]),
      ),
      ComplexMatrix.fromFlattenedData(
        rows: n,
        columns: n,
        data: List<Complex>.generate(n * n, (k) => v[order[k % n]][k ~/ n]),
      ),
    ];
  }

  /// Applies Jacobi rotations to pairs of columns of [w] (and the same
  /// rotations to the columns of [v]) until all the columns of [w] are
  /// orthogonal, up to the given relative [tolerance].
  ///
  /// Throws a [MatrixException] if the algorithm doesn't converge.
  void _orthogonalizeColumns(
    List<List<Complex>> w,
    List<List<Complex>> v, {
    required double tolerance,
  }) {
    final n = w.length;

    for (var sweep = 0; sweep < _maxSweeps; sweep++) {
      var rotated = false;

      for (var p = 0; p < n - 1; p++) {
        for (var q = p + 1; q < n; q++) {
          // The 2x2 Gram matrix of the columns p and q:
          //
          //  | alpha       gamma |
          //  | conj(gamma) beta  |
          var alpha = 0.0;
          var beta = 0.0;
          var gamma = const Complex.zero();
          for (var i = 0; i < w[p].length; i++) {
            alpha += _squaredAbs(w[p][i]);
            beta += _squaredAbs(w[q][i]);
            gamma += w[p][i].conjugate() * w[q][i];
          }

          // A column whose norm is below 'tolerance' times the norm of the
          // other one is numerically zero (decompose() gives it a zero
          // singular value) and its direction is just rounding noise, so
          // rotations can't make it orthogonal: it is skipped.
          final gammaAbs = gamma.abs();
          final isNegligible =
              min(alpha, beta) <= tolerance * tolerance * max(alpha, beta);
          if (isNegligible || gammaAbs <= tolerance * sqrt(alpha * beta)) {
            continue;
          }

          rotated = true;

          // The rotation that diagonalizes the Gram matrix. 't' is the
          // smallest root of t^2 + 2 zeta t - 1 = 0.
          final zeta = (beta - alpha) / (2 * gammaAbs);
          final t = (zeta >= 0 ? 1 : -1) / (zeta.abs() + hypot(1, zeta));
          final c = 1 / sqrt(1 + t * t);
          final s = c * t;
          final phase = gamma * Complex.fromReal(1 / gammaAbs);

          _rotate(w[p], w[q], c, s, phase);
          _rotate(v[p], v[q], c, s, phase);
        }
      }

      if (!rotated) {
        return;
      }
    }

    throw const MatrixException('The SVD algorithm did not converge.');
  }

  /// Replaces the columns [x] and [y] with:
  ///
  ///  - x' = c x - s conj(phase) y
  ///  - y' = s phase x + c y
  ///
  /// which is the product of `[x y]` with a unitary 2x2 matrix.
  static void _rotate(
    List<Complex> x,
    List<Complex> y,
    double c,
    double s,
    Complex phase,
  ) {
    final cc = Complex.fromReal(c);
    final sPhase = Complex.fromReal(s) * phase;
    final sConjugatePhase = Complex.fromReal(s) * phase.conjugate();

    for (var i = 0; i < x.length; i++) {
      final xi = x[i];
      final yi = y[i];
      x[i] = cc * xi - sConjugatePhase * yi;
      y[i] = sPhase * xi + cc * yi;
    }
  }

  /// Replaces each `null` entry of [columns] with a unit vector of size
  /// [size], orthogonal to all the other columns.
  ///
  /// Candidates are taken from the standard basis: at each step, the one with
  /// the largest component outside of the current span is chosen.
  void _completeBasis(List<List<Complex>?> columns, int size) {
    for (var j = 0; j < columns.length; j++) {
      if (columns[j] != null) {
        continue;
      }

      List<Complex>? best;
      var bestNorm = -1.0;

      for (var candidate = 0; candidate < size; candidate++) {
        final x = List<Complex>.generate(
          size,
          (i) =>
              i == candidate ? const Complex.fromReal(1) : const Complex.zero(),
        );

        // Orthogonalizing twice for numerical stability.
        for (var pass = 0; pass < 2; pass++) {
          for (final column in columns) {
            if (column == null) {
              continue;
            }

            var dot = const Complex.zero();
            for (var i = 0; i < size; i++) {
              dot += column[i].conjugate() * x[i];
            }
            for (var i = 0; i < size; i++) {
              x[i] -= dot * column[i];
            }
          }
        }

        final norm = _norm(x);
        if (norm > bestNorm) {
          bestNorm = norm;
          best = x;
        }
      }

      final factor = Complex.fromReal(1 / bestNorm);
      columns[j] = best!.map((value) => value * factor).toList();
    }
  }

  /// The 2-norm of [vector].
  double _norm(List<Complex> vector) =>
      vector.fold<double>(0, (norm, value) => hypot(norm, value.abs()));

  /// The squared magnitude of [value].
  static double _squaredAbs(Complex value) =>
      value.real * value.real + value.imaginary * value.imaginary;

  /// The conjugate transpose of [source].
  static ComplexMatrix _conjugateTranspose(ComplexMatrix source) =>
      ComplexMatrix.fromFlattenedData(
        rows: source.columnCount,
        columns: source.rowCount,
        data: List<Complex>.generate(
          source.rowCount * source.columnCount,
          (k) => source(k % source.rowCount, k ~/ source.rowCount).conjugate(),
        ),
      );
}
