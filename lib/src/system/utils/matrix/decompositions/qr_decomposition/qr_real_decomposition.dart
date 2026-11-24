import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// {@macro qr_decomposition_class_header}
///
/// This class performs the QR decomposition on [RealMatrix] types. Since the
/// data is real, `Q` has orthonormal columns: `Q^T x Q = I`.
///
/// Example:
/// ```dart
/// final matrix = RealMatrix.fromData(
///   rows: 3,
///   columns: 2,
///   data: [
///     [1, 2],
///     [3, 4],
///     [5, 6],
///   ],
/// );
/// final decomposition = QRDecompositionReal(matrix: matrix);
/// final [Q, R] = decomposition.decompose();
/// ```
final class QRDecompositionReal extends QRDecomposition<double, RealMatrix>
    with MathUtils {
  /// {@macro qr_decomposition_class_header}
  const new({required super.matrix});

  @override
  List<RealMatrix> decompose() {
    if (matrix.flattenData.any((value) => !value.isFinite)) {
      throw const MatrixException(
        'The QR decomposition cannot be computed on matrices with NaN or '
        'infinite values.',
      );
    }

    final rows = matrix.rowCount;
    final columns = matrix.columnCount;
    final k = min(rows, columns);

    // At the end, the upper triangular part of 'a' is R.
    final a = matrix.toListOfList();

    // The Householder vectors (with unit norm) of each step. A 'null' vector
    // means that the column was already zero, so no reflection was needed.
    final reflectors = List<List<double>?>.filled(k, null);

    for (var j = 0; j < k; j++) {
      // The 2-norm of the j-th column, from the diagonal downwards.
      var norm = 0.0;
      for (var i = j; i < rows; i++) {
        norm = hypot(norm, a[i][j]);
      }

      if (norm == 0) {
        continue;
      }

      // The reflection maps the column to (-alpha, 0, ..., 0). The sign of
      // alpha matches the diagonal element to avoid cancellation.
      final alpha = a[j][j] < 0 ? -norm : norm;
      final v = List<double>.generate(
        rows - j,
        (i) => i == 0 ? a[j][j] + alpha : a[j + i][j],
      );
      _normalize(v);
      reflectors[j] = v;

      // Applying H = I - 2 v v^T to the remaining columns.
      for (var c = j + 1; c < columns; c++) {
        var dot = 0.0;
        for (var i = 0; i < v.length; i++) {
          dot += v[i] * a[j + i][c];
        }
        for (var i = 0; i < v.length; i++) {
          a[j + i][c] -= 2 * dot * v[i];
        }
      }

      // The reflected column is known exactly.
      a[j][j] = -alpha;
      for (var i = j + 1; i < rows; i++) {
        a[i][j] = 0;
      }
    }

    // R is the k x columns upper triangular (or trapezoidal) part of 'a'.
    final R = List<double>.generate(k * columns, (index) {
      final i = index ~/ columns;
      final j = index % columns;

      return i <= j ? a[i][j] : 0;
    });

    // Q = H(0) x H(1) x ... x H(k-1) x [I; 0] is built by applying the
    // reflections backwards to the first k columns of the identity matrix.
    final q = List<List<double>>.generate(
      rows,
      (i) => List<double>.generate(k, (j) => i == j ? 1 : 0),
    );

    for (var j = k - 1; j >= 0; j--) {
      final v = reflectors[j];
      if (v == null) {
        continue;
      }

      for (var c = 0; c < k; c++) {
        var dot = 0.0;
        for (var i = 0; i < v.length; i++) {
          dot += v[i] * q[j + i][c];
        }
        for (var i = 0; i < v.length; i++) {
          q[j + i][c] -= 2 * dot * v[i];
        }
      }
    }

    return [
      RealMatrix.fromData(rows: rows, columns: k, data: q),
      RealMatrix.fromFlattenedData(rows: k, columns: columns, data: R),
    ];
  }

  /// Scales [v] so that its 2-norm is 1.
  void _normalize(List<double> v) {
    var norm = 0.0;
    for (final value in v) {
      norm = hypot(norm, value);
    }

    for (var i = 0; i < v.length; i++) {
      v[i] /= norm;
    }
  }
}
