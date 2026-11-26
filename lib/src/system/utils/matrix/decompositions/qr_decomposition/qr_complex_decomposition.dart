import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// {@macro qr_decomposition_class_header}
///
/// This class performs the QR decomposition on [ComplexMatrix] types. Since
/// the data is complex, `Q` has orthonormal columns with respect to the
/// conjugate transpose: `Q^H x Q = I`.
///
/// Example:
/// ```dart
/// final matrix = ComplexMatrix.fromData(
///   rows: 3,
///   columns: 2,
///   data: [
///     [Complex(1, 0), Complex(2, 1)],
///     [Complex(3, -1), Complex(4, 0)],
///     [Complex(5, 2), Complex(6, -1)],
///   ],
/// );
/// final decomposition = QRDecompositionComplex(matrix: matrix);
/// final [Q, R] = decomposition.decompose();
/// ```
final class QRDecompositionComplex
    extends QRDecomposition<Complex, ComplexMatrix> {
  /// {@macro qr_decomposition_class_header}
  const new({required super.matrix});

  @override
  List<ComplexMatrix> decompose() {
    if (matrix.flattenData.any(
      (value) => !value.real.isFinite || !value.imaginary.isFinite,
    )) {
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
    final reflectors = List<List<Complex>?>.filled(k, null);

    for (var j = 0; j < k; j++) {
      // The 2-norm of the j-th column, from the diagonal downwards.
      var norm = 0.0;
      for (var i = j; i < rows; i++) {
        norm = hypot(norm, _magnitude(a[i][j]));
      }

      if (norm == 0) {
        continue;
      }

      // The reflection maps the column to (-alpha, 0, ..., 0), where alpha
      // has the same phase of the diagonal element to avoid cancellation.
      final diagonal = a[j][j];
      final diagonalAbs = _magnitude(diagonal);
      final alpha = diagonalAbs == 0
          ? Complex.fromReal(norm)
          : diagonal * Complex.fromReal(norm / diagonalAbs);

      final v = List<Complex>.generate(
        rows - j,
        (i) => i == 0 ? diagonal + alpha : a[j + i][j],
      );
      _normalize(v);
      reflectors[j] = v;

      // Applying H = I - 2 v v^H to the remaining columns.
      for (var c = j + 1; c < columns; c++) {
        _reflect(v, a, j, c);
      }

      // The reflected column is known exactly.
      a[j][j] = -alpha;
      for (var i = j + 1; i < rows; i++) {
        a[i][j] = const Complex.zero();
      }
    }

    // R is the k x columns upper triangular (or trapezoidal) part of 'a'.
    final R = List<Complex>.generate(k * columns, (index) {
      final i = index ~/ columns;
      final j = index % columns;

      return i <= j ? a[i][j] : const Complex.zero();
    });

    // Q = H(0) x H(1) x ... x H(k-1) x [I; 0] is built by applying the
    // reflections backwards to the first k columns of the identity matrix.
    final q = List<List<Complex>>.generate(
      rows,
      (i) => List<Complex>.generate(
        k,
        (j) => i == j ? const Complex.fromReal(1) : const Complex.zero(),
      ),
    );

    for (var j = k - 1; j >= 0; j--) {
      final v = reflectors[j];
      if (v == null) {
        continue;
      }

      for (var c = 0; c < k; c++) {
        _reflect(v, q, j, c);
      }
    }

    return [
      ComplexMatrix.fromData(rows: rows, columns: k, data: q),
      ComplexMatrix.fromFlattenedData(rows: k, columns: columns, data: R),
    ];
  }

  /// Applies the reflection `H = I - 2 v v^H` to the column [column] of
  /// [data], starting from row [offset].
  static void _reflect(
    List<Complex> v,
    List<List<Complex>> data,
    int offset,
    int column,
  ) {
    var dot = const Complex.zero();
    for (var i = 0; i < v.length; i++) {
      dot += v[i].conjugate() * data[offset + i][column];
    }

    final factor = dot * const Complex.fromReal(2);
    for (var i = 0; i < v.length; i++) {
      data[offset + i][column] -= factor * v[i];
    }
  }

  /// The magnitude of [value], computed without overflows or underflows.
  double _magnitude(Complex value) => hypot(value.real, value.imaginary);

  /// Scales [v] so that its 2-norm is 1.
  void _normalize(List<Complex> v) {
    var norm = 0.0;
    for (final value in v) {
      norm = hypot(norm, _magnitude(value));
    }

    final scale = Complex.fromReal(1 / norm);
    for (var i = 0; i < v.length; i++) {
      v[i] *= scale;
    }
  }
}
