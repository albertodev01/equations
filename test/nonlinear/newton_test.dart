import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Newton', () {
    test('Smoke test', () {
      const newton = Newton(function: 'sqrt(x) - e^2', x0: 52, maxSteps: 6);

      expect(newton.x0, equals(52));
      expect(newton.maxSteps, equals(6));
      expect(newton.tolerance, equals(1.0e-10));
      expect(newton.function, equals('sqrt(x) - e^2'));
      expect(newton.toString(), equals('f(x) = sqrt(x) - e^2'));

      // Solving the equation, making sure that the series converged
      final solutions = newton.solve();
      expect(solutions.guesses.length <= 6, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(
        solutions.convergence,
        const MoreOrLessEquals(2, precision: 1),
      );
      expect(
        solutions.efficiency,
        const MoreOrLessEquals(1.19, precision: 1.0e-2),
      );

      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(54.598, precision: 1.0e-3),
      );
    });

    test('Malformed equation string', () {
      expect(
        const Newton(function: 'sqrt4 - 2', x0: 1).solve,
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
      const newton = Newton(function: 'x-1', x0: 3);

      expect(const Newton(function: 'x-1', x0: 3), equals(newton));
      expect(const Newton(function: 'x-1', x0: 3) == newton, isTrue);
      expect(newton, equals(const Newton(function: 'x-1', x0: 3)));
      expect(newton == const Newton(function: 'x-1', x0: 3), isTrue);
      expect(const Newton(function: 'x-1', x0: 3.1) == newton, isFalse);
      expect(
        const Newton(function: 'x-1', x0: 3).hashCode,
        equals(newton.hashCode),
      );
    });

    test('Default maximum number of steps', () {
      expect(const Newton(function: 'x-1', x0: 3).maxSteps, equals(30));
    });

    test('Derivatives can be evaluated on 0', () {
      const newton = Newton(function: 'x-1', x0: 0);
      expect(
        newton.evaluateDerivativeOn(0),
        const MoreOrLessEquals(1, precision: 1.0e-8),
      );
      expect(
        newton.solve().guesses.last,
        const MoreOrLessEquals(1, precision: 1.0e-10),
      );
    });

    test('Returns the initial guess when it is the exact root', () {
      final solutions = const Newton(function: 'x-1', x0: 1).solve();
      expect(solutions.guesses, equals([1.0]));
    });

    test('Throws when the derivative is zero', () {
      expect(
        const Newton(function: 'x^2-1', x0: 0).solve,
        throwsA(
          isA<NonlinearException>().having(
            (e) => e.message,
            'message',
            equals("Couldn't evaluate f'(0.0). The derivative is zero"),
          ),
        ),
      );
    });

    test('Throws when the function value is NaN', () {
      expect(
        const Newton(function: 'sqrt(x)-3', x0: -5).solve,
        throwsA(
          isA<NonlinearException>().having(
            (e) => e.message,
            'message',
            equals("Couldn't evaluate f(-5.0). The function value is NaN."),
          ),
        ),
      );
    });

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double x0,
        double expectedSolution,
      ) {
        final solutions = Newton(function: equation, x0: x0).solve();
        expect(
          solutions.guesses.last,
          MoreOrLessEquals(expectedSolution, precision: 1.0e-3),
        );
        expect(solutions.guesses.length, isNonZero);
      }

      test('Test 1', () {
        verifySolution('x^e-cos(x)', 0.5, 0.856);
      });

      test('Test 2', () {
        verifySolution('3*x-sqrt(x+2)-1', -1, 0.901);
      });

      test('Test 3', () {
        verifySolution('x^3-5*x^2', 4, 5);
      });

      test('Test 4', () {
        verifySolution('x^2-13', 2, 3.605);
      });

      test('Test 5', () {
        verifySolution('e^(x)*(x+1)', -1.432, -1);
      });

      test('Test 6', () {
        verifySolution('x', -1, 0);
      });

      test('Test 7', () {
        verifySolution('sin(x+2)*cos(x-1)', 1.5, 1.141592);
      });

      test('Test 8', () {
        verifySolution('x^x-1', 0.5, 1);
      });

      test('Test 9', () {
        verifySolution('cos(x)-x', 0.5, 0.739085);
      });

      test('Test 10', () {
        verifySolution('log(x)-1', 2, 2.718282);
      });

      test('Test 11', () {
        verifySolution('x^3-2*x-5', 2, 2.094551);
      });

      test('Test 12', () {
        verifySolution('e^(-x)-x', 0.5, 0.567143);
      });

      test('Test 13', () {
        verifySolution('x^3+x+1', -0.5, -0.682328);
      });

      test('Test 14', () {
        verifySolution('x^2-1000000', 800, 1000);
      });

      test('Test 15', () {
        verifySolution('(x-1)^3', 2, 1);
      });

      test('Test 16', () {
        verifySolution('sin(x)', 3, 3.141593);
      });

      test('Test 17', () {
        verifySolution('x^5-x-1', 1.5, 1.167304);
      });

      test('Test 18', () {
        verifySolution('atan(x)', 0.5, 0);
      });

      test('Test 19', () {
        verifySolution('1/x-2', 0.3, 0.5);
      });
    });
  });
}
