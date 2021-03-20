import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Brent' class", () {
    test('Making sure that the series converges when the root is bracketed.',
        () {
      const brent = Brent(function: 'x^3-sqrt(x+3)', a: 0, b: 2, maxSteps: 10);

      expect(brent.a, equals(0));
      expect(brent.b, equals(2));
      expect(brent.maxSteps, equals(10));
      expect(brent.tolerance, equals(1.0e-10));
      expect(brent.function, equals('x^3-sqrt(x+3)'));
      expect(brent.toString(), equals('f(x) = x^3-sqrt(x+3)'));

      // Solving the equation, making sure that the series converged
      final solutions = brent.solve();
      expect(solutions.guesses.length <= 10, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, const MoreOrLessEquals(0, precision: 1));
      expect(
        solutions.efficiency,
        const MoreOrLessEquals(0.77, precision: 1.0e-2),
      );
      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1.27, precision: 1.0e-2),
      );
    });

    test('Making sure that a malformed equation string throws.', () {
      expect(
        () {
          const Brent(function: 'x^3-√(x+3)', a: 0, b: 2).solve();
        },
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Making sure that object comparison properly works', () {
      const newton = Brent(function: 'x-10', a: 8, b: 12);

      expect(const Brent(function: 'x-10', a: 8, b: 12), equals(newton));
      expect(const Brent(function: 'x-10', a: 8, b: 12) == newton, isTrue);
      expect(
        const Brent(function: 'x-10', a: 8, b: 12).hashCode,
        equals(newton.hashCode),
      );
    });

    test(
        'Making sure that an exception is thrown if the root is not bracketed '
        'because the [a,b] range is invalid.', () {
      const brent = Brent(function: 'x^3-sqrt(x+3)', a: 3, b: 5, maxSteps: 5);

      expect(brent.solve, throwsA(isA<NonlinearException>()));

      // Making sure the error message is correct
      try {
        brent.solve();
      } on NonlinearException catch (e) {
        expect(e.message, equals('The root is not bracketed.'));
      }
    });
  });
}
