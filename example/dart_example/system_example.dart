import 'package:equations/equations.dart';

void main() {
  final jacobi = JacobiSolver(
    equations: const [
      [2, 1],
      [5, 7],
    ],
    constants: [11, 13],
    x0: [1, 1],
  );

  print('$jacobi\n');
  print('${jacobi.toStringAugmented()}\n');
  print('known values: ${jacobi.knownValues}'); // [11, 13]
  print('initial guess: ${jacobi.x0}'); // [1, 1]
  print('matrix size: ${jacobi.size}'); // 2
  print('max. iterations: ${jacobi.maxSteps}'); // 30
  print('determinant: ${jacobi.determinant()}'); // 9

  for (final sol in jacobi.solve()) {
    print(' > x = $sol');
  }

  print('\n ============ \n');

  final lu = LUSolver(
    equations: const [
      [7, -2, 1],
      [14, -7, -3],
      [-7, 11, 18],
    ],
    constants: const [12, 17, 5],
  );

  print('$lu\n');
  print('${lu.toStringAugmented()}\n');
  print('known values: ${lu.knownValues}'); // [12, 17, 5]
  print('matrix size: ${lu.size}'); // 3
  print('determinant: ${lu.determinant()}\n'); // -84

  final decompose = lu.equations.luDecomposition();

  /*
  * L:
  * [1, 0, 0]
  * [2, 1, 0]
  * [-1, -3, 1]
  *
  * U:
  * [7, -2, 1]
  * [0, -3, -5]
  * [0, 0, 4]
  * */
  print('L:\n${decompose[0]}\n');
  print('U:\n${decompose[1]}\n');

  for (final sol in lu.solve()) {
    print(' > x = $sol');
  }
}
