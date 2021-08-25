import 'package:equations/equations.dart';

void main() {
  const newton = NewtonInterpolation(
    nodes: [
      InterpolationNode(x: 45, y: 0.7071),
      InterpolationNode(x: 50, y: 0.7660),
      InterpolationNode(x: 55, y: 0.8192),
      InterpolationNode(x: 60, y: 0.8660),
    ],
  );

  // Prints 0.788
  final y = newton.compute(52);
  print(y.toStringAsFixed(3));

  // Prints the following:
  //
  // [0.7071, 0.05890000000000006, -0.005700000000000038, -0.0007000000000000339]
  // [0.766, 0.053200000000000025, -0.006400000000000072, 0.0]
  // [0.8192, 0.04679999999999995, 0.0, 0.0]
  // [0.866, 0.0, 0.0, 0.0]
  print('\n${newton.forwardDifferenceTable()}');

  print('\n ============ \n');

  const polynomial = PolynomialInterpolation(
    nodes: [
      InterpolationNode(x: 0, y: -1),
      InterpolationNode(x: 1, y: 1),
      InterpolationNode(x: 4, y: 1),
    ],
  );

  // Prints -4.54
  final y2 = polynomial.compute(-1.15);
  print(y2.toStringAsFixed(2));

  // Prints -0.5x^2 + 2.5x + -1
  print('\n${polynomial.buildPolynomial()}');
}
