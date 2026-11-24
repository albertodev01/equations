import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

/// The default tolerance of the checks, relative to the magnitude of the
/// matrix elements.
const defaultTolerance = 1.0e-10;

/// The conjugate transpose of [matrix].
ComplexMatrix conjugateTranspose(ComplexMatrix matrix) =>
    ComplexMatrix.fromFlattenedData(
      rows: matrix.columnCount,
      columns: matrix.rowCount,
      data: List<Complex>.generate(
        matrix.rowCount * matrix.columnCount,
        (k) => matrix(k % matrix.rowCount, k ~/ matrix.rowCount).conjugate(),
      ),
    );

/// The largest magnitude among the elements of [matrix] (at least 1).
double _scale(Matrix<dynamic> matrix) => matrix.flattenData.fold<double>(1, (
  current,
  value,
) {
  final magnitude = value is Complex
      ? sqrt(value.real * value.real + value.imaginary * value.imaginary)
      : (value as double).abs();

  return max(current, magnitude);
});

/// Expects [actual] and [expected] to have the same shape and elements that
/// differ at most by [tolerance] (relative to the largest element of
/// [expected]).
void expectComplexMatrixClose(
  ComplexMatrix actual,
  ComplexMatrix expected, {
  double tolerance = defaultTolerance,
}) {
  expect(actual.rowCount, equals(expected.rowCount));
  expect(actual.columnCount, equals(expected.columnCount));

  final limit = tolerance * _scale(expected);
  for (var i = 0; i < expected.flattenData.length; i++) {
    final difference = actual.flattenData[i] - expected.flattenData[i];
    expect(difference.real.abs(), lessThanOrEqualTo(limit));
    expect(difference.imaginary.abs(), lessThanOrEqualTo(limit));
  }
}

/// Expects [actual] and [expected] to have the same shape and elements that
/// differ at most by [tolerance] (relative to the largest element of
/// [expected]).
void expectRealMatrixClose(
  RealMatrix actual,
  RealMatrix expected, {
  double tolerance = defaultTolerance,
}) {
  expect(actual.rowCount, equals(expected.rowCount));
  expect(actual.columnCount, equals(expected.columnCount));

  final limit = tolerance * _scale(expected);
  for (var i = 0; i < expected.flattenData.length; i++) {
    expect(
      (actual.flattenData[i] - expected.flattenData[i]).abs(),
      lessThanOrEqualTo(limit),
    );
  }
}

/// Expects [matrix] to be zero below the main diagonal.
void _expectUpperTriangular(Matrix<dynamic> matrix, Object zero) {
  for (var i = 0; i < matrix.rowCount; i++) {
    for (var j = 0; j < min(i, matrix.columnCount); j++) {
      expect(matrix(i, j), equals(zero));
    }
  }
}

/// Checks all the properties of the QR decomposition of a complex [matrix].
void expectValidComplexQR(ComplexMatrix matrix, List<ComplexMatrix> qr) {
  final k = min(matrix.rowCount, matrix.columnCount);
  final [q, r] = qr;

  expect(q.rowCount, equals(matrix.rowCount));
  expect(q.columnCount, equals(k));
  expect(r.rowCount, equals(k));
  expect(r.columnCount, equals(matrix.columnCount));

  _expectUpperTriangular(r, const Complex.zero());
  expectComplexMatrixClose(
    conjugateTranspose(q) * q,
    ComplexMatrix(rows: k, columns: k, identity: true),
  );
  expectComplexMatrixClose(q * r, matrix);
}

/// Checks all the properties of the QR decomposition of a real [matrix].
void expectValidRealQR(RealMatrix matrix, List<RealMatrix> qr) {
  final k = min(matrix.rowCount, matrix.columnCount);
  final [q, r] = qr;

  expect(q.rowCount, equals(matrix.rowCount));
  expect(q.columnCount, equals(k));
  expect(r.rowCount, equals(k));
  expect(r.columnCount, equals(matrix.columnCount));

  _expectUpperTriangular(r, 0.0);
  expectRealMatrixClose(
    q.transpose() * q,
    RealMatrix(rows: k, columns: k, identity: true),
  );
  expectRealMatrixClose(q * r, matrix);
}

/// Checks all the properties of the SVD of a complex [matrix] and returns the
/// singular values.
List<double> expectValidComplexSVD(
  ComplexMatrix matrix,
  List<ComplexMatrix> svd,
) {
  final m = matrix.rowCount;
  final n = matrix.columnCount;
  final [e, u, v] = svd;

  expect(e.rowCount, equals(m));
  expect(e.columnCount, equals(n));
  expect(u.rowCount, equals(m));
  expect(u.columnCount, equals(m));
  expect(v.rowCount, equals(n));
  expect(v.columnCount, equals(n));

  // E is diagonal, with real, non-negative and sorted values.
  final singularValues = <double>[];
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < n; j++) {
      if (i == j) {
        expect(e(i, j).imaginary, isZero);
        expect(e(i, j).real, greaterThanOrEqualTo(0));
        singularValues.add(e(i, j).real);
      } else {
        expect(e(i, j), equals(const Complex.zero()));
      }
    }
  }
  for (var i = 1; i < singularValues.length; i++) {
    expect(singularValues[i], lessThanOrEqualTo(singularValues[i - 1]));
  }

  // U and V are unitary and A = U x E x V^H.
  expectComplexMatrixClose(
    conjugateTranspose(u) * u,
    ComplexMatrix(rows: m, columns: m, identity: true),
  );
  expectComplexMatrixClose(
    conjugateTranspose(v) * v,
    ComplexMatrix(rows: n, columns: n, identity: true),
  );
  expectComplexMatrixClose(u * e * conjugateTranspose(v), matrix);

  return singularValues;
}

/// Checks all the properties of the SVD of a real [matrix] and returns the
/// singular values.
List<double> expectValidRealSVD(RealMatrix matrix, List<RealMatrix> svd) {
  final m = matrix.rowCount;
  final n = matrix.columnCount;
  final [e, u, v] = svd;

  expect(e.rowCount, equals(m));
  expect(e.columnCount, equals(n));
  expect(u.rowCount, equals(m));
  expect(u.columnCount, equals(m));
  expect(v.rowCount, equals(n));
  expect(v.columnCount, equals(n));

  // E is diagonal, with non-negative and sorted values.
  final singularValues = <double>[];
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < n; j++) {
      if (i == j) {
        expect(e(i, j), greaterThanOrEqualTo(0));
        singularValues.add(e(i, j));
      } else {
        expect(e(i, j), isZero);
      }
    }
  }
  for (var i = 1; i < singularValues.length; i++) {
    expect(singularValues[i], lessThanOrEqualTo(singularValues[i - 1]));
  }

  // U and V are orthogonal and A = U x E x V^T.
  expectRealMatrixClose(
    u.transpose() * u,
    RealMatrix(rows: m, columns: m, identity: true),
  );
  expectRealMatrixClose(
    v.transpose() * v,
    RealMatrix(rows: n, columns: n, identity: true),
  );
  expectRealMatrixClose(u * e * v.transpose(), matrix);

  return singularValues;
}

/// Checks all the properties of the eigendecomposition of a complex [matrix]
/// and returns the eigenvalues.
List<Complex> expectValidComplexEigendecomposition(
  ComplexMatrix matrix,
  List<ComplexMatrix> decomposition,
) {
  final n = matrix.rowCount;
  final [v, d, inverseV] = decomposition;

  for (final factor in decomposition) {
    expect(factor.rowCount, equals(n));
    expect(factor.columnCount, equals(n));
  }

  expect(d.isDiagonal(), isTrue);
  expectComplexMatrixClose(matrix * v, v * d);
  expectComplexMatrixClose(
    v * inverseV,
    ComplexMatrix(rows: n, columns: n, identity: true),
  );
  expectComplexMatrixClose(v * d * inverseV, matrix);

  return List<Complex>.generate(n, (i) => d(i, i));
}

/// Expects [actual] and [expected] to contain the same values (in any order),
/// up to the given [tolerance] relative to their magnitude.
///
/// Each expected value is paired with the closest actual value that hasn't
/// been paired yet.
void expectSameEigenvalues(
  List<Complex> actual,
  List<Complex> expected, {
  double tolerance = 1e-9,
}) {
  expect(actual.length, equals(expected.length));

  final remaining = [...actual];
  for (final value in expected) {
    var closest = 0;
    for (var i = 1; i < remaining.length; i++) {
      if ((remaining[i] - value).abs() < (remaining[closest] - value).abs()) {
        closest = i;
      }
    }

    expect(
      (remaining.removeAt(closest) - value).abs(),
      lessThanOrEqualTo(tolerance * max(1, value.abs())),
    );
  }
}
