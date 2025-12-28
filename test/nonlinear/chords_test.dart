import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Chords', () {
    test('Smoke test', () {
      const chords = Chords(
        function: 'cos(x+3)-log(x)+2',
        a: 0.1,
        b: 7,
        maxSteps: 5,
      );

      expect(chords.maxSteps, equals(5));
      expect(chords.tolerance, equals(1.0e-10));
      expect(chords.function, equals('cos(x+3)-log(x)+2'));
      expect(chords.toString(), equals('f(x) = cos(x+3)-log(x)+2'));
      expect(chords.a, equals(0.1));
      expect(chords.b, equals(7));

      // Solving the equation, making sure that the series converged
      final solutions = chords.solve();
      expect(solutions.guesses.length <= 5, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.guesses.last, const MoreOrLessEquals(5, precision: 1));
      expect(
        solutions.convergence,
        const MoreOrLessEquals(0.5, precision: 1),
      );
      expect(
        solutions.efficiency,
        const MoreOrLessEquals(0.8, precision: 1.0e-1),
      );
    });

    test('Malformed equation string', () {
      expect(
        const Chords(function: '2^ -6y', a: 2, b: 0).solve,
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
      const chords = Chords(
        function: 'x^2-2',
        a: 1,
        b: 2,
      );

      expect(const Chords(function: 'x^2-2', a: 1, b: 2), equals(chords));
      expect(const Chords(function: 'x^2-2', a: 1, b: 2) == chords, isTrue);
      expect(chords, equals(const Chords(function: 'x^2-2', a: 1, b: 2)));
      expect(chords == const Chords(function: 'x^2-2', a: 1, b: 2), isTrue);
      expect(const Chords(function: 'x^2-2', a: 0, b: 2) == chords, isFalse);
      expect(const Chords(function: 'x^2-2', a: 1, b: 3) == chords, isFalse);
      expect(
        const Chords(function: 'x^2-2', a: 1, b: 2).hashCode,
        equals(chords.hashCode),
      );
    });

    test(
      'Root not bracketed',
      () {
        const chords = Chords(function: 'x^2-2', a: 10, b: 20, maxSteps: 3);
        expect(chords.solve, throwsA(isA<NonlinearException>()));

        try {
          chords.solve();
        } on NonlinearException catch (e) {
          expect(
            e.message,
            equals(
              'The root is not bracketed in [10.0, 20.0]. f(a) and f(b) '
              'must have opposite signs.',
            ),
          );
        }
      },
    );

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double a,
        double b,
        double expectedSolution,
      ) {
        final solutions = Chords(function: equation, a: a, b: b).solve();
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
    });
  });
}
