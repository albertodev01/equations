import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Newton' class", () {
    test(
        'Making sure that the series converges when the root is in the interval.',
        () {
      const newtwon = Newton(function: 'sqrt(x) - e^2', x0: 52, maxSteps: 6);

      expect(newtwon.x0, equals(52));
      expect(newtwon.maxSteps, equals(6));
      expect(newtwon.tolerance, equals(1.0e-10));
      expect(newtwon.function, equals('sqrt(x) - e^2'));
      expect(newtwon.toString(), equals('f(x) = sqrt(x) - e^2'));

      // Solving the equation, making sure that the series converged
      final solutions = newtwon.solve();
      expect(solutions.guesses.length <= 6, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(
        solutions.convergence,
        const MoreOrLessEquals(2, precision: 1),
      );
      expect(
        solutions.efficiency,
        const MoreOrLessEquals(1.12, precision: 1.0e-2),
      );

      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(54.598, precision: 1.0e-3),
      );
    });

    test('Making sure that a malformed equation string throws.', () {
      expect(() {
        const Newton(function: 'sqrt4 - 2', x0: 0).solve();
      }, throwsA(isA<ExpressionParserException>()));
    });

    test('Making sure that object comparison properly works', () {
      const newton = Newton(function: 'x-1', x0: 3);

      expect(const Newton(function: 'x-1', x0: 3), equals(newton));
      expect(const Newton(function: 'x-1', x0: 3) == newton, isTrue);
      expect(const Newton(function: 'x-1', x0: 3.1) == newton, isFalse);
      expect(
        const Newton(function: 'x-1', x0: 3).hashCode,
        equals(newton.hashCode),
      );
    });

    test('Making sure that derivatives evaluated on 0 return NaN.', () {
      const newton = Newton(function: 'x', x0: 0);

      // The derivative on 0 is 'NaN'
      expect(newton.evaluateDerivativeOn(0).isNaN, isTrue);

      // Making sure that the method actually throws
      expect(newton.solve, throwsA(isA<Exception>()));
    });

    test(
        'Making sure that the newton method still works when the root is '
        'not in the interval but the actual solution is not found', () {
      const newton = Newton(function: 'x-500', x0: 2, maxSteps: 3);
      final solutions = newton.solve();

      expect(solutions.guesses.length, isNonZero);
      expect(solutions.guesses.length <= 3, isTrue);
    });

    test('Batch tests', () {
      final equations = [
        'x^e-cos(x)',
        '3*x-sqrt(x+2)-1',
        'x^3-5*x^2',
        'x^2-13',
        'e^(x)*(x+1)',
      ];

      final initialGuesses = <double>[
        1,
        0.6,
        7,
        2,
        0.5,
      ];

      final expectedSolutions = <double>[
        0.856,
        0.901,
        5.000,
        3.605,
        -1.000,
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          final solutions = Newton(
            function: equations[i],
            x0: initialGuesses[i],
            maxSteps: 80,
            tolerance: 1.0e-20,
          ).solve();

          expect(
            solutions.guesses.last,
            MoreOrLessEquals(expectedSolutions[i], precision: 1.0e-3),
          );
        }
      }
    });
  });
}
