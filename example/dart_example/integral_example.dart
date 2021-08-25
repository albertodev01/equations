import 'package:equations/equations.dart';

void main() {
  // ∫ sin(x) * e^x dx
  const simpson = SimpsonRule(
    lowerBound: 2,
    upperBound: 4,
  );

  final results = simpson.integrate('sin(x)*e^x');

  final result = results.result; // -7.71
  final steps = results.guesses.length; // 32

  print('Evaluation on (2; 4) = ${result.toStringAsFixed(2)}');
  print('Algorithm steps = $steps');

  print('\n ============ \n');

  // ∫ x^4 - 5x dx
  const trapezoid = TrapezoidalRule(
    lowerBound: 0,
    upperBound: 1,
  );

  final results2 = trapezoid.integrate('x^4-5*x');

  final result2 = results2.result; // -2.30
  final steps2 = results2.guesses.length; // 20

  print('Evaluation on (0; 1) = ${result2.toStringAsFixed(2)}');
  print('Algorithm steps = $steps2');
}
