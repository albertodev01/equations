import 'package:equations/equations.dart';

void main() {
  // Both 'RealMatrix' and 'ComplexMatrix' have the same usage and the same
  // methods. The only difference is that 'RealMatrix' works with real numbers
  // (represented by a 'double' type) while 'ComplexMatrix' works with complex
  // numbers(represented by a 'Complex' type).
  final emptyMatrix = RealMatrix(
    columns: 5,
    rows: 3,
  );
  print('Empty matrix:\n$emptyMatrix'); // The matrix is filled with zeroes

  print('\n ============ \n');

  /*
    * A = |  2  6  |
    *     | -5  0  |
    * */
  final matrixA = RealMatrix.fromData(columns: 2, rows: 2, data: const [
    [2, 6],
    [-5, 0]
  ]);

  /*
    * B = | -4  1  |
    *     |  7 -3  |
    * */
  final matrixB = RealMatrix.fromData(columns: 2, rows: 2, data: const [
    [-4, 1],
    [7, -3]
  ]);

  print('A + B:\n${matrixA + matrixB}\n'); // the sum of 2 matrices
  print('A - B:\n${matrixA - matrixB}\n'); // the difference of 2 matrices
  print('A * B:\n${matrixA * matrixB}\n'); // the product of 2 matrices
  print('A / B:\n${matrixA / matrixB}\n'); // the division of 2 matrices

  print('\n ============ \n');

  final matrixLU = RealMatrix.fromData(
    rows: 3,
    columns: 3,
    data: const [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ],
  );

  // LU decomposition of a matrix
  final lu = matrixLU.luDecomposition();

  /*
  * L:
  * [1, 0, 0]
  * [4, 1, 0]
  * [7, 2, 1]
  *
  * U:
  * [1, 2, 3]
  * [0, -3, -6]
  * [0, 0, 0]
  * */
  print('L:\n${lu[0]}\n');
  print('U:\n${lu[1]}\n');

  print('\n ============ \n');

  final matrixCholesky = RealMatrix.fromData(
    rows: 3,
    columns: 3,
    data: const [
      [25, 15, -5],
      [15, 18, 0],
      [-5, 0, 11]
    ],
  );

  // LU decomposition of a matrix
  final cholesky = matrixCholesky.choleskyDecomposition();

  /*
  * L:
  * [5, 0, 0]
  * [3, 3, 0]
  * [-1, 1, 3]
  *
  * L transposed:
  * [5, 3, -1]
  * [0, 3, 1]
  * [0, 0, 3]
  * */
  print('L:\n${cholesky[0]}\n');
  print('L transposed:\n${cholesky[1]}\n');
}
