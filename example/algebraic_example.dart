import 'package:equations/equations.dart';

void main() {
  // f(x) = x^3 + 7x^2 + 2x - 5
  final cubic = Cubic.realEquation(a: 1, b: 7, c: 2, d: -5);

  print('$cubic'); // f(x) = 1x^3 + 7x^2 + 2x + -5
  print('discriminant: ${cubic.discriminant()}'); // 5089
  print('derivative: ${cubic.derivative()}'); // 3x^2 + 14x + 2
  print('degree: ${cubic.degree}'); // 3
  print('valid input? ${cubic.isValid}'); // true
  print('are all coefficients real? ${cubic.isRealEquation}\n'); // true

  for (final sol in cubic.solutions()) {
    print(' > x = $sol');
  }

  print('\n ============ \n');

  // f(x) = ix^2 + (8 - 3i)
  final quadratic = Algebraic.from(const [
    Complex.i(),
    Complex.zero(),
    Complex(8, -3),
  ]);

  print('$quadratic'); // f(x) = 1ix^2 + (8 - 3i)
  print('discriminant: ${quadratic.discriminant()}'); // -12 - 32i
  print('derivative: ${quadratic.derivative()}'); // 2ix
  print('degree: ${quadratic.degree}'); // 2
  print('valid input? ${quadratic.isValid}'); // true
  print('are all coefficients real? ${quadratic.isRealEquation}\n'); // false

  for (final sol in quadratic.solutions()) {
    print(' > x = $sol');
  }
}
