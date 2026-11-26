import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Bisection', () {
    test('Smoke test', () {
      const bisection = Bisection(
        function: 'x^3-x-2',
        a: 1,
        b: 2,
        maxSteps: 5,
      );

      expect(bisection.maxSteps, equals(5));
      expect(bisection.tolerance, equals(1.0e-10));
      expect(bisection.function, equals('x^3-x-2'));
      expect(bisection.toString(), equals('f(x) = x^3-x-2'));
      expect(bisection.a, equals(1));
      expect(bisection.b, equals(2));

      // Solving the equation, making sure that the series converged
      final solutions = bisection.solve();
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, const MoreOrLessEquals(1, precision: 1));
      expect(solutions.efficiency, const MoreOrLessEquals(1, precision: 1));

      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1.5, precision: 1.0e-1),
      );
    });

    test('Malformed equation string', () {
      expect(
        () {
          const Bisection(function: '2x - 6', a: 1, b: 8).solve();
        },
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
      const bisection = Bisection(
        function: 'x-2',
        a: 1,
        b: 2,
      );

      expect(
        const Bisection(function: 'x-2', a: 1, b: 2),
        equals(bisection),
      );
      expect(
        bisection,
        equals(const Bisection(function: 'x-2', a: 1, b: 2)),
      );
      expect(
        const Bisection(function: 'x-2', a: 0, b: 2) == bisection,
        isFalse,
      );
      expect(
        const Bisection(function: 'x-2', a: 1, b: 2.1) == bisection,
        isFalse,
      );
      expect(
        const Bisection(function: 'x-2', a: 1, b: 2).hashCode,
        equals(bisection.hashCode),
      );
    });

    test('Throws when root is not bracketed', () {
      const bisection = Bisection(function: 'x^2 - 9', a: -120, b: -122);
      expect(bisection.solve, throwsA(isA<NonlinearException>()));

      try {
        bisection.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          equals(
            'The root is not bracketed in [-120.0, -122.0]. f(a) and f(b) '
            'must have opposite signs.',
          ),
        );
      }
    });

    test('Returns the endpoint when it is a root', () {
      expect(
        const Bisection(function: 'x-1', a: 1, b: 2).solve().guesses,
        equals([1.0]),
      );
      expect(
        const Bisection(function: 'x-2', a: 1, b: 2).solve().guesses,
        equals([2.0]),
      );
    });

    test('Works with very small function values', () {
      // f(a) * f(b) underflows to zero, but the root is bracketed
      final solutions = Bisection(
        function: '0.${'0' * 199}1*(x-1.5)',
        a: 1,
        b: 2,
      ).solve();
      expect(solutions.guesses.last, equals(1.5));
    });

    test('Throws when the function is not finite at an endpoint', () {
      expect(
        const Bisection(function: 'sqrt(x)-1', a: -1, b: 2).solve,
        throwsA(
          isA<NonlinearException>().having(
            (e) => e.message,
            'message',
            equals("Couldn't evaluate f(-1.0). The function value is NaN."),
          ),
        ),
      );
    });

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double a,
        double b,
        double expectedSolution,
      ) {
        final solutions = Bisection(function: equation, a: a, b: b).solve();
        expect(
          solutions.guesses.last,
          MoreOrLessEquals(expectedSolution, precision: 1.0e-3),
        );
        expect(solutions.guesses.length, isNonZero);
      }

      test('Test 1', () {
        verifySolution('x^e-cos(x)', 0.5, 1, 0.856);
      });

      test('Test 2', () {
        verifySolution('3*x-sqrt(x+2)-1', -1, 1, 0.901);
      });

      test('Test 3', () {
        verifySolution('x^3-5*x^2', 4, 6, 5);
      });

      test('Test 4', () {
        verifySolution('x^2-13', 3, 4, 3.605);
      });

      test('Test 5', () {
        verifySolution('e^(x)*(x+1)', -2, 0, -1);
      });

      test('Test 6', () {
        verifySolution('x', -1, 1, 0);
      });

      test('Test 7', () {
        verifySolution('sin(x+2)*cos(x-1)', 0.5, 1.5, 1.141592);
      });

      test('Test 8', () {
        verifySolution('x^x-1', 0.5, 1.1, 1);
      });

      test('Test 9', () {
        verifySolution('cos(x)-x', 0, 1, 0.739085);
      });

      test('Test 10', () {
        verifySolution('log(x)-1', 1, 4, 2.718282);
      });

      test('Test 11', () {
        verifySolution('x^3-2*x-5', 2, 3, 2.094551);
      });

      test('Test 12', () {
        verifySolution('e^(-x)-x', 0, 1, 0.567143);
      });

      test('Test 13', () {
        verifySolution('x^3+x+1', -1, 0, -0.682328);
      });

      test('Test 14', () {
        verifySolution('x^2-1000000', 600, 1500, 1000);
      });

      test('Test 15', () {
        verifySolution('(x-1)^3', 0, 2.5, 1);
      });

      test('Test 16', () {
        verifySolution('sin(x)', 3, 4, 3.141593);
      });

      test('Test 17', () {
        verifySolution('x^5-x-1', 1, 2, 1.167304);
      });

      test('Test 18', () {
        verifySolution('atan(x)', -1, 2, 0);
      });

      test('Test 19', () {
        verifySolution('1/x-2', 0.2, 1, 0.5);
      });
    });
  });
}
