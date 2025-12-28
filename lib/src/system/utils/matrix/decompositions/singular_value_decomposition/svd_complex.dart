import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/single_value_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// {@macro svd_class_header}
///
/// This class performs the SVD procedure on [ComplexMatrix] types.
///
/// The implementation handles complex numbers throughout the decomposition
/// process. The algorithm uses complex arithmetic for all operations and
/// properly handles complex singular values and vectors.
///
/// The convergence criteria and numerical stability checks are adapted for
/// complex number operations. The algorithm includes a maximum iteration limit
/// to prevent infinite loops in pathological cases.
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
final class SVDComplex extends SingleValueDecomposition<Complex, ComplexMatrix>
    with MathUtils {
  /// Epsilon value for numerical stability in complex operations.
  static const _epsilon = 1e-10;

  /// Tiny value threshold for very small numbers.
  static const _tiny = 1e-300;

  /// Maximum number of iterations allowed for convergence.
  static const _maxIterations = 1000;

  /// {@macro svd_class_header}
  const SVDComplex({required super.matrix});

  /// Reduces the source matrix to bidiagonal form using Householder
  /// reflections.
  ///
  /// This is the first step of the SVD algorithm and is required for the
  /// computation of `U` and `V`. The bidiagonal form simplifies the
  /// subsequent iterative refinement of singular values.
  ///
  /// The method modifies the input matrices in place and populates the
  /// arrays with the necessary transformation data.
  void _bidiagonalForm({
    required List<List<Complex>> sourceMatrix,
    required List<List<Complex>> matrixU,
    required List<List<Complex>> matrixV,
    required List<Complex> arrayS,
    required List<Complex> arrayE,
    required List<Complex> helperArray,
  }) {
    final nct = min(matrix.rowCount - 1, matrix.columnCount);
    final nrt = max(0, min(matrix.columnCount - 2, matrix.rowCount));

    for (var k = 0; k < max(nct, nrt); k++) {
      if (k < nct) {
        arrayS[k] = const Complex.zero();

        // Square
        for (var i = k; i < matrix.rowCount; i++) {
          arrayS[k] = complexHypot(arrayS[k], sourceMatrix[i][k]);
        }

        if (arrayS[k].abs() > _epsilon) {
          // Handle sign based on complex number properties
          if (sourceMatrix[k][k].real < 0 ||
              (sourceMatrix[k][k].real == 0 &&
                  sourceMatrix[k][k].imaginary < 0)) {
            arrayS[k] = -arrayS[k];
          }

          // Dividing each by the k-th element of the values array.
          for (var i = k; i < matrix.rowCount; i++) {
            sourceMatrix[i][k] /= arrayS[k];
          }
          sourceMatrix[k][k] += const Complex.fromReal(1);
        } else {
          throw Exception('Matrix is numerically singular');
        }
        arrayS[k] = -arrayS[k];
      }

      for (var j = k + 1; j < matrix.columnCount; j++) {
        // Applying the transformation making sure that s[k] is NOT zero.
        if ((k < nct) && (arrayS[k].abs() > _epsilon)) {
          var t = const Complex.zero();
          for (var i = k; i < matrix.rowCount; i++) {
            t += sourceMatrix[i][k] * sourceMatrix[i][j];
          }

          t = -t / sourceMatrix[k][k];
          for (var i = k; i < matrix.rowCount; i++) {
            sourceMatrix[i][j] += t * sourceMatrix[i][k];
          }
        }

        // Storing the row at position 'k' in the arrayE's k-th position for the
        // next row transformation computation step.
        arrayE[j] = sourceMatrix[k][j];
      }

      if (k < nct) {
        // Storing data in U for the next back multipication.
        for (var i = k; i < matrix.rowCount; i++) {
          matrixU[i][k] = sourceMatrix[i][k];
        }
      }

      if (k < nrt) {
        arrayE[k] = const Complex.zero();

        // 'complexHypot' computes sqrt(x^2 + y^2) without under/overflow.
        for (var i = k + 1; i < matrix.columnCount; i++) {
          arrayE[k] = complexHypot(arrayE[k], arrayE[i]);
        }

        if (arrayE[k].abs() > _epsilon) {
          for (var i = k + 1; i < matrix.columnCount; i++) {
            arrayE[i] /= arrayE[k];
          }
          arrayE[k + 1] += const Complex.fromReal(1);
        } else {
          throw Exception('Matrix is numerically singular');
        }

        arrayE[k] = -arrayE[k];

        // Starting the transformation process.
        if ((k + 1 < matrix.rowCount) && (arrayE[k].abs() > _epsilon)) {
          for (var i = k + 1; i < matrix.rowCount; i++) {
            helperArray[i] = const Complex.zero();
          }

          for (var j = k + 1; j < matrix.columnCount; j++) {
            for (var i = k + 1; i < matrix.rowCount; i++) {
              helperArray[i] += arrayE[j] * sourceMatrix[i][j];
            }
          }

          for (var j = k + 1; j < matrix.columnCount; j++) {
            final t = -arrayE[j] / arrayE[k + 1];
            for (var i = k + 1; i < matrix.rowCount; i++) {
              sourceMatrix[i][j] += t * helperArray[i];
            }
          }
        }

        // Initialization for the computation of V.
        for (var i = k + 1; i < matrix.columnCount; i++) {
          matrixV[i][k] = arrayE[i];
        }
      }
    }

    // Set up the final bidiagonal matrix of order p.
    final p = min(matrix.columnCount, matrix.rowCount + 1);
    if (nct < matrix.columnCount) {
      arrayS[nct] = sourceMatrix[nct][nct];
    }
    if (matrix.rowCount < p) {
      arrayS[p - 1] = const Complex.zero();
    }
    if (nrt + 1 < p) {
      arrayE[nrt] = sourceMatrix[nrt][p - 1];
    }
    arrayE[p - 1] = const Complex.zero();
  }

  /// Generates the `U` matrix from the bidiagonal transformation data.
  ///
  /// This method reconstructs the left singular vectors by accumulating the
  /// Householder transformations applied during bidiagonalization. The
  /// resulting matrix U is unitary (U^H U = I, where H denotes conjugate
  /// transpose).
  void _generateU({
    required List<List<Complex>> matrixU,
    required List<Complex> arrayS,
  }) {
    final maxRowCol = max(matrix.rowCount, matrix.columnCount);
    final nct = min(matrix.rowCount - 1, matrix.columnCount);

    // Generation of U based on the previous transformations. Works with square
    // and rectangular matrices.
    for (var j = nct; j < maxRowCol; j++) {
      for (var i = 0; i < matrix.rowCount; i++) {
        if (i == j) {
          matrixU[j][j] = const Complex.fromReal(1);
        } else {
          matrixU[i][j] = const Complex.zero();
        }
      }
    }

    for (var k = nct - 1; k >= 0; k--) {
      if (arrayS[k].abs() > _epsilon) {
        for (var j = k + 1; j < maxRowCol; j++) {
          var t = const Complex.zero();
          for (var i = k; i < matrix.rowCount; i++) {
            t += matrixU[i][k] * matrixU[i][j];
          }
          t = -t / matrixU[k][k];
          for (var i = k; i < matrix.rowCount; i++) {
            matrixU[i][j] += t * matrixU[i][k];
          }
        }
        for (var i = k; i < matrix.rowCount; i++) {
          matrixU[i][k] = -matrixU[i][k];
        }
        matrixU[k][k] = const Complex.fromReal(1) + matrixU[k][k];
        for (var i = 0; i < k - 1; i++) {
          matrixU[i][k] = const Complex.zero();
        }
      } else {
        for (var i = 0; i < matrix.rowCount; i++) {
          matrixU[i][k] = const Complex.zero();
        }
        matrixU[k][k] = const Complex.fromReal(1);
      }
    }
  }

  /// Generates the `V` matrix from the bidiagonal transformation data.
  ///
  /// This method reconstructs the right singular vectors by accumulating the
  /// Householder transformations applied during bidiagonalization. The
  /// resulting matrix V is unitary (V^H V = I, where H denotes conjugate
  /// transpose).
  void _generateV({
    required List<List<Complex>> matrixV,
    required List<Complex> arrayE,
  }) {
    final nrt = max(0, min(matrix.columnCount - 2, matrix.rowCount));

    // Generation of V based on the previous transformations. Works with square
    // and rectangular matrices.
    for (var k = matrix.columnCount - 1; k >= 0; k--) {
      if ((k < nrt) && (arrayE[k].abs() > _epsilon)) {
        for (var j = k + 1; j < matrixV.first.length; j++) {
          var t = const Complex.zero();
          for (var i = k + 1; i < matrix.columnCount; i++) {
            t += matrixV[i][k] * matrixV[i][j];
          }
          t = -t / matrixV[k + 1][k];
          for (var i = k + 1; i < matrix.columnCount; i++) {
            matrixV[i][j] += t * matrixV[i][k];
          }
        }
      }
      for (var i = 0; i < matrix.columnCount; i++) {
        matrixV[i][k] = const Complex.zero();
      }
      matrixV[k][k] = const Complex.fromReal(1);
    }
  }

  @override
  List<ComplexMatrix> decompose() {
    // Input validation
    if (matrix.rowCount == 0 || matrix.columnCount == 0) {
      throw ArgumentError('Matrix dimensions must be positive');
    }

    // Cache matrix dimensions
    final rowCount = matrix.rowCount;
    final columnCount = matrix.columnCount;
    final maxRowCol = max(rowCount, columnCount);

    // This matrix as a list of lists (to easily alter data)
    final sourceMatrix = matrix.toListOfList();

    // Arrays for internal storage of U and V.
    final matrixU = List<List<Complex>>.generate(
      rowCount,
      (_) => List<Complex>.generate(maxRowCol, (_) => const Complex.zero()),
      growable: false,
    );
    final matrixV = List<List<Complex>>.generate(
      columnCount,
      (_) => List<Complex>.generate(columnCount, (_) => const Complex.zero()),
      growable: false,
    );

    // Array for internal storage of the singular values.
    final arrayS = List<Complex>.generate(
      min(rowCount + 1, columnCount),
      (_) => const Complex.zero(),
      growable: false,
    );
    final arrayE = List<Complex>.generate(
      columnCount,
      (_) => const Complex.zero(),
      growable: false,
    );
    final helperArray = List<Complex>.generate(
      rowCount,
      (_) => const Complex.zero(),
      growable: false,
    );

    // Setup 1: bidiagonal form
    _bidiagonalForm(
      sourceMatrix: sourceMatrix,
      matrixU: matrixU,
      matrixV: matrixV,
      arrayS: arrayS,
      arrayE: arrayE,
      helperArray: helperArray,
    );

    // Setup 2: generating U
    _generateU(matrixU: matrixU, arrayS: arrayS);

    // Setup 3: generating V.
    _generateV(matrixV: matrixV, arrayE: arrayE);

    // === Computing singular values from here. === //
    var p = min<int>(columnCount, rowCount + 1);
    final pp = p - 1;
    var step = 0;
    var iterationCount = 0;

    // Main iteration loop for the singular values.
    while (p > 0 && iterationCount < _maxIterations) {
      iterationCount++;

      // The 'convergenceStatus' variable works along with 'index' to determine
      // when the iterations should stop. In particular:
      //
      //  - 'convergenceStatus' = 1: if s(p) && e[k-1] are small enough && k < p
      //  - 'convergenceStatus' = 2: if s(k) is small enough and k < p
      //  - 'convergenceStatus' = 3: if e[k-1] is small enough && k < p && a QR
      //                             step is required since values in s(*) are
      //                             NOT small enough
      //  - 'convergenceStatus' = 4: convergence reached
      var convergenceStatus = 0;
      var index = 0;

      for (index = p - 2; index >= -1; index--) {
        if (index == -1) {
          break;
        }

        final upper =
            _tiny + _epsilon * (arrayS[index].abs() + arrayS[index + 1].abs());
        if (arrayE[index].abs() <= upper) {
          arrayE[index] = const Complex.zero();
          break;
        }
      }

      if (index == p - 2) {
        // Convergence
        convergenceStatus = 4;
      } else {
        var ks = 0;
        for (ks = p - 1; ks >= index; ks--) {
          if (ks == index) {
            break;
          }
          final t =
              (ks != p ? arrayE[ks].abs() : 0) +
              (ks != index + 1 ? arrayE[ks - 1].abs() : 0);
          if (arrayS[ks].abs() <= _tiny + _epsilon * t) {
            arrayS[ks] = const Complex.zero();
            break;
          }
        }
        if (ks == index) {
          convergenceStatus = 3;
        } else if (ks == p - 1) {
          convergenceStatus = 1;
        } else {
          convergenceStatus = 2;
          index = ks;
        }
      }

      index++;

      // Now that the convergence status is updated, we proceed with different
      // strategies according with the flag.
      switch (convergenceStatus) {
        case 1:
          var f = arrayE[p - 2];
          arrayE[p - 2] = const Complex.zero();
          for (var j = p - 2; j >= index; j--) {
            var t = complexHypot(arrayS[j], f);
            final cs = arrayS[j] / t;
            final sn = f / t;
            arrayS[j] = t;
            if (j != index) {
              f = -sn * arrayE[j - 1];
              arrayE[j - 1] = cs * arrayE[j - 1];
            }
            for (var i = 0; i < columnCount; i++) {
              t = cs * matrixV[i][j] + sn * matrixV[i][p - 1];
              matrixV[i][p - 1] = -sn * matrixV[i][j] + cs * matrixV[i][p - 1];
              matrixV[i][j] = t;
            }
          }

        case 2:
          var f = arrayE[index - 1];
          arrayE[index - 1] = const Complex.zero();
          for (var j = index; j < p; j++) {
            var t = complexHypot(arrayS[j], f);
            final cs = arrayS[j] / t;
            final sn = f / t;
            arrayS[j] = t;
            f = -sn * arrayE[j];
            arrayE[j] = cs * arrayE[j];
            for (var i = 0; i < rowCount; i++) {
              t = cs * matrixU[i][j] + sn * matrixU[i][index - 1];
              matrixU[i][index - 1] =
                  -sn * matrixU[i][j] + cs * matrixU[i][index - 1];
              matrixU[i][j] = t;
            }
          }

        case 3:
          // QR step with shifting
          final scaledValue = max(
            max(
              max(
                max(arrayS[p - 1].abs(), arrayS[p - 2].abs()),
                arrayE[p - 2].abs(),
              ),
              arrayS[index].abs(),
            ),
            arrayE[index].abs(),
          );

          final scale = Complex.fromReal(scaledValue);
          final sp = arrayS[p - 1] / scale;
          final spm1 = arrayS[p - 2] / scale;
          final epm1 = arrayE[p - 2] / scale;
          final sk = arrayS[index] / scale;
          final ek = arrayE[index] / scale;
          final b =
              ((spm1 + sp) * (spm1 - sp) + epm1 * epm1) /
              const Complex.fromReal(2);
          final c = (sp * epm1) * (sp * epm1);
          var shift = const Complex.zero();

          if ((b.abs() > _epsilon) || (c.abs() > _epsilon)) {
            shift = (b * b + c).sqrt();
            shift = c / (b + shift);
          }
          var f = (sk + sp) * (sk - sp) + shift;
          var g = sk * ek;

          // Looking for 0s.
          for (var j = index; j < p - 1; j++) {
            var t = complexHypot(f, g);
            var cs = f / t;
            var sn = g / t;
            if (j != index) {
              arrayE[j - 1] = t;
            }
            f = cs * arrayS[j] + sn * arrayE[j];
            arrayE[j] = cs * arrayE[j] - sn * arrayS[j];
            g = sn * arrayS[j + 1];
            arrayS[j + 1] = cs * arrayS[j + 1];
            for (var i = 0; i < columnCount; i++) {
              t = cs * matrixV[i][j] + sn * matrixV[i][j + 1];
              matrixV[i][j + 1] = -sn * matrixV[i][j] + cs * matrixV[i][j + 1];
              matrixV[i][j] = t;
            }
            t = complexHypot(f, g);
            cs = f / t;
            sn = g / t;
            arrayS[j] = t;
            f = cs * arrayE[j] + sn * arrayS[j + 1];
            arrayS[j + 1] = -sn * arrayE[j] + cs * arrayS[j + 1];
            g = sn * arrayE[j + 1];
            arrayE[j + 1] = cs * arrayE[j + 1];
            for (var i = 0; i < rowCount; i++) {
              t = cs * matrixU[i][j] + sn * matrixU[i][j + 1];
              matrixU[i][j + 1] = -sn * matrixU[i][j] + cs * matrixU[i][j + 1];
              matrixU[i][j] = t;
            }
          }

          arrayE[p - 2] = f;
          step = step + 1;

        case 4:
          // Changing sign to singular values to make them positive.
          if (arrayS[index].abs() <= _epsilon) {
            arrayS[index] = const Complex.zero();
            for (var i = 0; i <= pp; i++) {
              matrixV[i][index] = -matrixV[i][index];
            }
          }

          // Before returning E, U and V we need to rearrange the values.
          while (index < pp) {
            if (arrayS[index].abs() >= arrayS[index + 1].abs()) {
              break;
            }
            var temp = arrayS[index];
            arrayS[index] = arrayS[index + 1];
            arrayS[index + 1] = temp;
            if (index < columnCount - 1) {
              for (var i = 0; i < columnCount; i++) {
                temp = matrixV[i][index + 1];
                matrixV[i][index + 1] = matrixV[i][index];
                matrixV[i][index] = temp;
              }
            }
            if (index < rowCount - 1) {
              for (var i = 0; i < rowCount; i++) {
                temp = matrixU[i][index + 1];
                matrixU[i][index + 1] = matrixU[i][index];
                matrixU[i][index] = temp;
              }
            }
            index++;
          }
          step = 0;
          p--;
      }
    }

    if (iterationCount >= _maxIterations) {
      throw Exception('SVD did not converge within maximum iterations');
    }

    // Building the 'E' rectangular matrix, whose size is rowCount*columnCount.
    final sAsMatrix = List<List<Complex>>.generate(
      rowCount,
      (_) => List<Complex>.generate(columnCount, (_) => const Complex.zero()),
      growable: false,
    );
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        if (i == j) {
          sAsMatrix[i][j] = arrayS[i];
        } else {
          sAsMatrix[i][j] = const Complex.zero();
        }
      }
    }

    // Returning E, U and V.
    return [
      ComplexMatrix.fromData(
        rows: rowCount,
        columns: columnCount,
        data: sAsMatrix,
      ),
      ComplexMatrix.fromData(rows: rowCount, columns: maxRowCol, data: matrixU),
      ComplexMatrix.fromData(
        rows: columnCount,
        columns: columnCount,
        data: matrixV,
      ),
    ];
  }
}
