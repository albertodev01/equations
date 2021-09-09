import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/single_value_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// Single Value Decomposition decomposition, also known as a SVD, is a
/// decomposition of a matrix A into a product `A = U x E x Vt` of:
///
///   - a square unitary matrix U
///   - a rectangular diagonal matrix E with positive values on the diagonal
///   - a square unitary matrix V
///
/// This class performs the SVD procedure on [RealMatrix] types.
class SVDReal extends SingleValueDecomposition<double, RealMatrix>
    with MathUtils {
  /// Requires the [realMatrix] matrix to be decomposed.
  const SVDReal({
    required RealMatrix realMatrix,
  }) : super(matrix: realMatrix);

  /// Reduces the source matrix a to bidiagonal form.
  ///
  /// This is required for the computation of `U` and `V`.
  void _bidiagonalForm({
    required List<List<double>> sourceMatrix,
    required List<List<double>> matrixU,
    required List<List<double>> matrixV,
    required List<double> arrayS,
    required List<double> arrayE,
    required List<double> helperArray,
  }) {
    final nct = min(matrix.rowCount - 1, matrix.columnCount);
    final nrt = max(0, min(matrix.columnCount - 2, matrix.rowCount));

    for (var k = 0; k < max(nct, nrt); k++) {
      if (k < nct) {
        arrayS[k] = 0;

        // Square
        for (var i = k; i < matrix.rowCount; i++) {
          arrayS[k] = hypot(arrayS[k], sourceMatrix[i][k]);
        }

        if (arrayS[k] != 0.0) {
          // Fixing the sign.
          if (sourceMatrix[k][k] < 0.0) {
            arrayS[k] = -arrayS[k];
          }

          // Dividing each by the k-th element of the values array.
          for (int i = k; i < matrix.rowCount; i++) {
            sourceMatrix[i][k] /= arrayS[k];
          }
          sourceMatrix[k][k] += 1.0;
        }
        arrayS[k] = -arrayS[k];
      }

      for (var j = k + 1; j < matrix.columnCount; j++) {
        // Applying the transformation making sure that s[k] is NOT zero.
        if ((k < nct) && (arrayS[k] != 0.0)) {
          var t = 0.0;
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
        arrayE[k] = 0;

        // 'hypot' computes sqrt(x^2 + y^2) without under/overflow.
        for (var i = k + 1; i < matrix.columnCount; i++) {
          arrayE[k] = hypot(arrayE[k], arrayE[i]);
        }

        if (arrayE[k] != 0.0) {
          if (arrayE[k + 1] < 0.0) {
            arrayE[k] = -arrayE[k];
          }
          for (var i = k + 1; i < matrix.columnCount; i++) {
            arrayE[i] /= arrayE[k];
          }
          arrayE[k + 1] += 1.0;
        }

        arrayE[k] = -arrayE[k];

        // Starting the transformation process.
        if ((k + 1 < matrix.rowCount) && (arrayE[k] != 0.0)) {
          for (var i = k + 1; i < matrix.rowCount; i++) {
            helperArray[i] = 0.0;
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
      arrayS[p - 1] = 0.0;
    }
    if (nrt + 1 < p) {
      arrayE[nrt] = sourceMatrix[nrt][p - 1];
    }
    arrayE[p - 1] = 0.0;
  }

  /// Generation of the `U` from a bidiagonal source.
  void _generateU({
    required List<List<double>> matrixU,
    required List<double> arrayS,
  }) {
    final maxRowCol = max(matrix.rowCount, matrix.columnCount);
    final nct = min<int>(matrix.rowCount - 1, matrix.columnCount);

    // Generation of U based on the previous transformations. Works with square
    // and rectangular matrices.
    for (var j = nct; j < maxRowCol; j++) {
      for (var i = 0; i < matrix.rowCount; i++) {
        if (i == j) {
          matrixU[j][j] = 1.0;
        } else {
          matrixU[i][j] = 0.0;
        }
      }
    }

    for (var k = nct - 1; k >= 0; k--) {
      if (arrayS[k] != 0.0) {
        for (var j = k + 1; j < maxRowCol; j++) {
          var t = 0.0;
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
        matrixU[k][k] = 1.0 + matrixU[k][k];
        for (var i = 0; i < k - 1; i++) {
          matrixU[i][k] = 0.0;
        }
      } else {
        for (var i = 0; i < matrix.rowCount; i++) {
          matrixU[i][k] = 0.0;
        }
        matrixU[k][k] = 1.0;
      }
    }
  }

  /// Generation of the `V` from a bidiagonal source.
  void _generateV({
    required List<List<double>> matrixV,
    required List<double> arrayE,
  }) {
    final nrt = max(0, min(matrix.columnCount - 2, matrix.rowCount));

    // Generation of V based on the previous transformations. Works with square
    // and rectangular matrices.
    for (var k = matrix.columnCount - 1; k >= 0; k--) {
      if ((k < nrt) && (arrayE[k] != 0.0)) {
        for (var j = k + 1; j < matrixV[0].length; j++) {
          var t = 0.0;
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
        matrixV[i][k] = 0.0;
      }
      matrixV[k][k] = 1.0;
    }
  }

  @override
  List<RealMatrix> decompose() {
    // This matrix as a list of lists (to easily alter data)
    final sourceMatrix = matrix.toListOfList();
    final maxRowCol = max(matrix.rowCount, matrix.columnCount);

    // Arrays for internal storage of U and V.
    final matrixU = List<List<double>>.generate(matrix.rowCount, (_) {
      return List<double>.generate(
        maxRowCol,
        (_) => 0,
      );
    });
    final matrixV = List<List<double>>.generate(matrix.columnCount, (_) {
      return List<double>.generate(matrix.columnCount, (_) => 0);
    });

    // Array for internal storage of the singular values.
    final arrayS = List<double>.generate(
      min(matrix.rowCount + 1, matrix.columnCount),
      (_) => 0,
    );
    final arrayE = List<double>.generate(
      matrix.columnCount,
      (_) => 0,
    );
    final helperArray = List<double>.generate(
      matrix.rowCount,
      (_) => 0,
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
    _generateU(
      matrixU: matrixU,
      arrayS: arrayS,
    );

    // Setup 3: generating V.
    _generateV(
      matrixV: matrixV,
      arrayE: arrayE,
    );

    // === Computing singular values from here. === //
    var p = min<int>(matrix.columnCount, matrix.rowCount + 1);
    final pp = p - 1;
    var step = 0;

    // Precision.
    final eps = pow(2.0, -52.0) as double;
    final tiny = pow(2.0, -966.0) as double;

    // Main iteration loop for the singular values.
    while (p > 0) {
      // The 'convergenceStatus' variable works along with 'index' to determine
      // when the iterations should stop. In particular:
      //
      //  - 'convergenceStatus' = 1: if s(p) && e[k-1] are small enough and k < p
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
            tiny + eps * (arrayS[index].abs() + arrayS[index + 1]).abs();
        if (arrayE[index].abs() <= upper) {
          arrayE[index] = 0.0;
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
          final t = (ks != p ? arrayE[ks].abs() : 0.0) +
              (ks != index + 1 ? arrayE[ks - 1].abs() : 0.0);
          if (arrayS[ks].abs() <= tiny + eps * t) {
            arrayS[ks] = 0.0;
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
          arrayE[p - 2] = 0.0;
          for (var j = p - 2; j >= index; j--) {
            var t = hypot(arrayS[j], f);
            final cs = arrayS[j] / t;
            final sn = f / t;
            arrayS[j] = t;
            if (j != index) {
              f = -sn * arrayE[j - 1];
              arrayE[j - 1] = cs * arrayE[j - 1];
            }
            for (var i = 0; i < matrix.columnCount; i++) {
              t = cs * matrixV[i][j] + sn * matrixV[i][p - 1];
              matrixV[i][p - 1] = -sn * matrixV[i][j] + cs * matrixV[i][p - 1];
              matrixV[i][j] = t;
            }
          }
          break;

        case 2:
          var f = arrayE[index - 1];
          arrayE[index - 1] = 0.0;
          for (int j = index; j < p; j++) {
            var t = hypot(arrayS[j], f);
            final double cs = arrayS[j] / t;
            final double sn = f / t;
            arrayS[j] = t;
            f = -sn * arrayE[j];
            arrayE[j] = cs * arrayE[j];
            for (var i = 0; i < matrix.rowCount; i++) {
              t = cs * matrixU[i][j] + sn * matrixU[i][index - 1];
              matrixU[i][index - 1] =
                  -sn * matrixU[i][j] + cs * matrixU[i][index - 1];
              matrixU[i][j] = t;
            }
          }
          break;

        case 3:
          // QR step with shifting
          final scale = max(
            max(
              max(
                max(
                  arrayS[p - 1].abs(),
                  arrayS[p - 2].abs(),
                ),
                arrayE[p - 2].abs(),
              ),
              arrayS[index].abs(),
            ),
            arrayE[index].abs(),
          );

          final sp = arrayS[p - 1] / scale;
          final spm1 = arrayS[p - 2] / scale;
          final epm1 = arrayE[p - 2] / scale;
          final sk = arrayS[index] / scale;
          final ek = arrayE[index] / scale;
          final b = ((spm1 + sp) * (spm1 - sp) + epm1 * epm1) / 2.0;
          final c = (sp * epm1) * (sp * epm1);
          var shift = 0.0;

          if ((b != 0.0) | (c != 0.0)) {
            shift = sqrt(b * b + c);
            if (b < 0.0) {
              shift = -shift;
            }
            shift = c / (b + shift);
          }
          var f = (sk + sp) * (sk - sp) + shift;
          var g = sk * ek;

          // Looking for 0s.
          for (int j = index; j < p - 1; j++) {
            var t = hypot(f, g);
            var cs = f / t;
            var sn = g / t;
            if (j != index) {
              arrayE[j - 1] = t;
            }
            f = cs * arrayS[j] + sn * arrayE[j];
            arrayE[j] = cs * arrayE[j] - sn * arrayS[j];
            g = sn * arrayS[j + 1];
            arrayS[j + 1] = cs * arrayS[j + 1];
            for (var i = 0; i < matrix.columnCount; i++) {
              t = cs * matrixV[i][j] + sn * matrixV[i][j + 1];
              matrixV[i][j + 1] = -sn * matrixV[i][j] + cs * matrixV[i][j + 1];
              matrixV[i][j] = t;
            }
            t = hypot(f, g);
            cs = f / t;
            sn = g / t;
            arrayS[j] = t;
            f = cs * arrayE[j] + sn * arrayS[j + 1];
            arrayS[j + 1] = -sn * arrayE[j] + cs * arrayS[j + 1];
            g = sn * arrayE[j + 1];
            arrayE[j + 1] = cs * arrayE[j + 1];
            for (var i = 0; i < matrix.rowCount; i++) {
              t = cs * matrixU[i][j] + sn * matrixU[i][j + 1];
              matrixU[i][j + 1] = -sn * matrixU[i][j] + cs * matrixU[i][j + 1];
              matrixU[i][j] = t;
            }
          }

          arrayE[p - 2] = f;
          step = step + 1;
          break;

        case 4:
          // Changing sign to singular values to make them positive.
          if (arrayS[index] <= 0.0) {
            arrayS[index] = arrayS[index] < 0.0 ? -arrayS[index] : 0.0;
            for (var i = 0; i <= pp; i++) {
              matrixV[i][index] = -matrixV[i][index];
            }
          }

          // Before returning E, U and V we need to rearrange the values.
          while (index < pp) {
            if (arrayS[index] >= arrayS[index + 1]) {
              break;
            }
            var temp = arrayS[index];
            arrayS[index] = arrayS[index + 1];
            arrayS[index + 1] = temp;
            if (index < matrix.columnCount - 1) {
              for (var i = 0; i < matrix.columnCount; i++) {
                temp = matrixV[i][index + 1];
                matrixV[i][index + 1] = matrixV[i][index];
                matrixV[i][index] = temp;
              }
            }
            if (index < matrix.rowCount - 1) {
              for (var i = 0; i < matrix.rowCount; i++) {
                temp = matrixU[i][index + 1];
                matrixU[i][index + 1] = matrixU[i][index];
                matrixU[i][index] = temp;
              }
            }
            index++;
          }

          step = 0;
          p--;
          break;
      }
    }

    // Building the 'E' rectangular matrix, whose size is rowCount * columnCount
    final sAsMatrix = List<List<double>>.generate(matrix.rowCount, (_) {
      return List<double>.generate(matrix.columnCount, (_) => 0);
    });
    for (int i = 0; i < matrix.rowCount; i++) {
      for (int j = 0; j < matrix.columnCount; j++) {
        if (i == j) {
          sAsMatrix[i][j] = arrayS[i];
        } else {
          sAsMatrix[i][j] = 0.0;
        }
      }
    }

    // Returning E, U and V.
    return [
      // E
      RealMatrix.fromData(
        rows: matrix.rowCount,
        columns: matrix.columnCount,
        data: sAsMatrix,
      ),
      // U
      RealMatrix.fromData(
        rows: matrix.rowCount,
        columns: maxRowCol,
        data: matrixU,
      ),
      // V
      RealMatrix.fromData(
        rows: matrix.columnCount,
        columns: matrix.columnCount,
        data: matrixV,
      ),
    ];
  }
}
