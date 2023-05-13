import 'dart:io';

import 'package:equation_solver_cli/src/output.dart';
import 'package:equations/equations.dart';

/// Solves a system of equations and shows details of the associated matrix.
class MatrixOutput extends Output {
  /// Creates an [MatrixOutput] object.
  const MatrixOutput();

  @override
  void processOutput() {
    final matrix = RealMatrix.fromData(
      rows: 4,
      columns: 4,
      data: [
        [16, -12, -12, -16],
        [-12, 25, 1, -4],
        [-12, 1, 17, 14],
        [-16, -4, 14, 57],
      ],
    );
    const knownValues = [7.0, 3.0, 6.0, -2.0];

    // Decompositions
    final lu = matrix.luDecomposition();
    final cholesky = matrix.choleskyDecomposition();
    final qr = matrix.qrDecomposition();
    final svd = matrix.singleValueDecomposition();

    // Solvers
    final gaussianElimination = GaussianElimination(
      matrix: matrix,
      knownValues: knownValues,
    );

    final gaussSolver = gaussianElimination.solve();
    final luSolver = LUSolver(
      matrix: matrix,
      knownValues: knownValues,
    ).solve();
    final choleskySolver = CholeskySolver(
      matrix: matrix,
      knownValues: knownValues,
    ).solve();
    final sorSolver = SORSolver(
      matrix: matrix,
      knownValues: knownValues,
      w: 1.25,
    ).solve();

    final output = StringBuffer()
      ..writeln('\n  --- Matrix analysis --- \n')
      ..writeln(matrix.toString())
      ..write('\n > Determinant: ')
      ..writeln(matrix.determinant())
      ..write(' > Is diagonal? ')
      ..writeln(matrix.isDiagonal())
      ..write(' > Is symmetric? ')
      ..writeln(matrix.isSymmetric())
      ..write(' > Determinant: ')
      ..writeln(matrix.isIdentity())
      ..write(' > Rank: ')
      ..writeln(matrix.rank())
      ..write(' > Trace: ')
      ..writeln(matrix.trace())
      ..write(' > Characteristic poly.: ')
      ..writeln(matrix.characteristicPolynomial())
      ..write(' > Eigenvalues: ')
      ..writeln(matrix.eigenvalues())
      ..writeln('\n  --- LU Decomposition --- \n')
      ..writeln(lu.first)
      ..writeln()
      ..writeln(lu[1])
      ..writeln('\n  --- Cholesky Decomposition --- \n')
      ..writeln(cholesky.first)
      ..writeln()
      ..writeln(cholesky[1])
      ..writeln('\n  --- QR Decomposition --- \n')
      ..writeln(qr.first)
      ..writeln()
      ..writeln(qr[1])
      ..writeln('\n  --- SVD Decomposition --- \n')
      ..writeln(svd.first)
      ..writeln()
      ..writeln(svd[1])
      ..writeln()
      ..writeln(svd[2])
      ..writeln('\n  --- System solving --- \n')
      ..writeln(gaussianElimination.toStringAugmented())
      ..write('\n > Gaussian elimination: ')
      ..writeln(gaussSolver)
      ..write(' > LU: ')
      ..writeln(luSolver)
      ..write(' > Cholesky: ')
      ..writeln(choleskySolver)
      ..write(' > SOR: ')
      ..writeln(sorSolver);

    stdout
      ..writeln('===== SYSTEM EVALUATION =====\n')
      ..writeln(output.toString());
  }
}
