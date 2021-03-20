import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Steffensen' class", () {
    test(
        'Making sure that the series converges when the root is in the interval.',
        () {
      const steffensen = Steffensen(function: 'exp(x)-3', x0: 1, maxSteps: 5);

      expect(steffensen.maxSteps, equals(5));
      expect(steffensen.tolerance, equals(1.0e-10));
      expect(steffensen.function, equals('exp(x)-3'));
      expect(steffensen.toString(), equals('f(x) = exp(x)-3'));
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
    });

    test('Making sure that a malformed equation string throws.', () {
      expect(() {
        const Steffensen(function: 'exp x - 3', x0: 1).solve();
      }, throwsA(isA<ExpressionParserException>()));
    });

    test('Making sure that object comparison properly works', () {
      const steffensen = Steffensen(function: 'exp(x)-3', x0: 3);

      expect(
        const Steffensen(function: 'exp(x)-3', x0: 3),
        equals(steffensen),
      );
      expect(
        const Steffensen(function: 'exp(x)-3', x0: 3) == steffensen,
        isTrue,
      );
      expect(
        const Steffensen(function: 'exp(x)-3', x0: 3).hashCode,
        equals(steffensen.hashCode),
      );
    });

    test(
        'Making sure that the steffensen method still works when the root is '
        'not in the interval but the actual solution is not found', () {
      const steffensen = Steffensen(function: 'x-500', x0: 1, maxSteps: 3);
      final solutions = steffensen.solve();

      expect(solutions.guesses.length, isNonZero);
      expect(solutions.guesses.length <= 3, isTrue);
    });
  });
}
