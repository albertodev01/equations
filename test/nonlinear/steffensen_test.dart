import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Steffensen', () {
    test(
      'Smoke test',
      () {
        const steffensen = Steffensen(function: 'e^x-3', x0: 1, maxSteps: 5);

        expect(steffensen.maxSteps, equals(5));
        expect(steffensen.tolerance, equals(1.0e-10));
        expect(steffensen.function, equals('e^x-3'));
        expect(steffensen.toString(), equals('f(x) = e^x-3'));
        expect(steffensen.x0, equals(1));

        // Solving the equation, making sure that the series converged
        final solutions = steffensen.solve();
        expect(solutions.guesses.length <= 5, isTrue);
        expect(solutions.guesses.length, isNonZero);
        expect(
          solutions.convergence,
          const MoreOrLessEquals(2, precision: 1.0e-1),
        );
        expect(
          solutions.efficiency,
          const MoreOrLessEquals(1.15, precision: 1.0e-2),
        );

        expect(
          solutions.guesses.last,
          const MoreOrLessEquals(1.098, precision: 1.0e-3),
        );
      },
    );

    test('Malformed equation string', () {
      expect(
        const Steffensen(function: '', x0: 1).solve,
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
      const steffensen = Steffensen(function: 'e^x-3', x0: 3);

      expect(const Steffensen(function: 'e^x-3', x0: 3), equals(steffensen));
      expect(const Steffensen(function: 'e^x-3', x0: 3) == steffensen, isTrue);
      expect(steffensen, equals(const Steffensen(function: 'e^x-3', x0: 3)));
      expect(steffensen == const Steffensen(function: 'e^x-3', x0: 3), isTrue);
      expect(
        const Steffensen(function: 'e^x-3', x0: 3.1) == steffensen,
        isFalse,
      );
      expect(
        const Steffensen(function: 'e^x-3', x0: 3).hashCode,
        equals(steffensen.hashCode),
      );
    });

    test('Throws when function value is NaN or infinite', () {
      const steffensen = Steffensen(function: 'sqrt(x)', x0: -1);
      expect(steffensen.solve, throwsA(isA<NonlinearException>()));

      try {
        steffensen.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          contains("Couldn't evaluate f(-1.0). The function value is NaN"),
        );
      }

      const steffensen2 = Steffensen(function: '1/x', x0: 0);
      expect(steffensen2.solve, throwsA(isA<NonlinearException>()));
    });

    test('Throws when gx is 0, NaN, or infinite', () {
      const steffensen2 = Steffensen(function: 'x^2', x0: -2);
      expect(steffensen2.solve, throwsA(isA<NonlinearException>()));

      try {
        steffensen2.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          contains("Couldn't compute the next iteration"),
        );
        expect(e.message, contains('The value g(x) is not well defined'));
      }
    });

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double x0,
        double expectedSolution,
      ) {
        final solutions = Steffensen(function: equation, x0: x0).solve();
        expect(
          solutions.guesses.last,
          MoreOrLessEquals(expectedSolution, precision: 1.0e-3),
        );
        expect(solutions.guesses.length, isNonZero);
      }

      test('Test 1', () {
        verifySolution('x^e-cos(x)', 0.8, 0.856);
      });

      test('Test 2', () {
        verifySolution('3*x-sqrt(x+2)-1', 0.5, 0.901);
      });

      test('Test 3', () {
        verifySolution('x^3-5*x^2', 4, 5);
      });

      test('Test 4', () {
        verifySolution('x^2-13', 4, 3.605);
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
        verifySolution('x^x-1', 0.8, 1);
      });
    });
  });
}
