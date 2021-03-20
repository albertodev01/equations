import 'package:equations/equations.dart';

void main() {
  // f(x) = 2x + cos(x)
  const newton = const Newton(function: '2*x + cos(x)', x0: -1, maxSteps: 4);

  print('$newton');
  print('initial guess: ${newton.x0}'); // -1
  print('max. iterations: ${newton.maxSteps}'); // 8
  print('tolerance: ${newton.tolerance}\n'); // 1.0e-10

  final solutions = newton.solve();

  print('convergence: ${solutions.convergence}'); // 1.99759...
  print('efficiency: ${solutions.efficiency}'); // 1.18884...

  for (final sol in solutions.guesses) {
    print(' > x = $sol');
  }

  print('\n ============ \n');

  // f(x) = 2x + cos(x)
  const bisection =
      Bisection(function: '2*x + cos(x)', a: -0.2, b: -1.17, maxSteps: 4);

  print('$bisection');
  print('lower bound: ${bisection.a}'); // -1
  print('max. iterations: ${bisection.maxSteps}'); // 8
  print('tolerance: ${bisection.tolerance}\n'); // 1.0e-10

  final solutions2 = bisection.solve();

  print('convergence: ${solutions2.convergence}'); // 1
  print('efficiency: ${solutions2.efficiency}'); // 1

  for (final sol in solutions2.guesses) {
    print(' > x = $sol');
  }
}
