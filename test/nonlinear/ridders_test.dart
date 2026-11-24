import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Ridders', () {
    test('Smoke test', () {
      const ridders = Ridders(
        function: 'x^3-x-2',
        a: 1,
        b: 2,
        maxSteps: 10,
        tolerance: 1.0e-15,
      );

      expect(ridders.maxSteps, equals(10));
      expect(ridders.tolerance, equals(1.0e-15));
      expect(ridders.function, equals('x^3-x-2'));
      expect(ridders.toString(), equals('f(x) = x^3-x-2'));
      expect(ridders.a, equals(1));
      expect(ridders.b, equals(2));

      // Solving the equation, making sure that the series converged
      final solutions = ridders.solve();
      expect(solutions.guesses.length <= 10, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(
        solutions.convergence,
        const MoreOrLessEquals(1, precision: 1),
      );
      expect(
        solutions.efficiency,
        const MoreOrLessEquals(1, precision: 1),
      );

      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1.5, precision: 1.0e-1),
      );
    });

    test('Malformed equation string', () {
      expect(
        const Ridders(function: '5x^2-2', a: 0, b: 2).solve,
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
      const ridders = Ridders(
        function: 'x-2',
        a: 1,
        b: 2,
      );

      expect(const Ridders(function: 'x-2', a: 1, b: 2), equals(ridders));
      expect(const Ridders(function: 'x-2', a: 0, b: 2) == ridders, isFalse);
      expect(ridders, equals(const Ridders(function: 'x-2', a: 1, b: 2)));
      expect(const Ridders(function: 'x-2', a: 0, b: 2) == ridders, isFalse);
      expect(const Ridders(function: 'x-2', a: 1, b: 1) == ridders, isFalse);
      expect(
        const Ridders(function: 'x-2', a: 1, b: 2).hashCode,
        equals(ridders.hashCode),
      );
    });

    test('Making sure that the method throws if the root is not bracketed', () {
      const ridders = Ridders(function: 'x^2-2', a: 100, b: 200);
      expect(ridders.solve, throwsA(isA<NonlinearException>()));

      try {
        ridders.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          equals(
            'The root is not bracketed in [100.0, 200.0]. f(a) and f(b) '
            'must have opposite signs.',
          ),
        );
      }
    });

    test('Throws when function value at midpoint is NaN or infinite', () {
      const ridders2 = Ridders(function: '1/(x-0.5)', a: 0, b: 1);
      expect(ridders2.solve, throwsA(isA<NonlinearException>()));

      try {
        ridders2.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          contains("Couldn't evaluate f("),
        );
        expect(
          e.message,
          anyOf(
            contains('NaN'),
            contains('infinite'),
          ),
        );
      }
    });

    test('Throws when function value at computed point is NaN or infinite', () {
      const ridders2 = Ridders(function: '1/(x-1)', a: 0, b: 2);
      expect(ridders2.solve, throwsA(isA<NonlinearException>()));

      try {
        ridders2.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          contains("Couldn't evaluate f("),
        );
        expect(
          e.message,
          anyOf(
            contains('NaN'),
            contains('infinite'),
          ),
        );
      }
    });

    test('Keeps the root bracketed in all branches', () {
      const ridders = Ridders(function: 'x^3 - 3*x', a: -2, b: 2);
      final solutions = ridders.solve();
      expect(solutions.guesses.length, isNonZero);
    });

    test('Works when a > b', () {
      final solutions = const Ridders(function: 'x^3-x-2', a: 2, b: 1).solve();
      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1.5213797068, precision: 1.0e-10),
      );
    });

    test('Keeps the root bracketed', () {
      for (final function in const ['e^x-10', '10-e^x']) {
        final solutions = Ridders(function: function, a: 0, b: 5).solve();
        expect(solutions.guesses.length, lessThanOrEqualTo(6));
        expect(
          solutions.guesses.last,
          const MoreOrLessEquals(2.302585093, precision: 1.0e-9),
        );
      }
    });

    test('Returns the endpoint when it is a root', () {
      expect(
        const Ridders(function: 'x-1', a: 1, b: 2).solve().guesses,
        equals([1.0]),
      );
      expect(
        const Ridders(function: 'x-2', a: 1, b: 2).solve().guesses,
        equals([2.0]),
      );
    });

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double a,
        double b,
        double expectedSolution,
      ) {
        final solutions = Ridders(function: equation, a: a, b: b).solve();
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
