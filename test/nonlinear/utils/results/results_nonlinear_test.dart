import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('Testing the behaviors of the NonlinearResults class.', () {
    const results = NonlinearResults(
      guesses: [1.0, 2.0, 3.0],
      convergence: 10,
      efficiency: -7,
    );

    test('Making that NonlinearResults values are properly constructed.', () {
      expect(results.guesses, orderedEquals(<double>[1, 2, 3]));
      expect(results.convergence, equals(10.0));
      expect(results.efficiency, equals(-7.0));
    });

    test('Making sure that "NonlinearResults" overrides "toString()".', () {
      const strResult = 'Convergence rate: 10.0\n'
          'Efficiency: -7.0\n'
          'Guesses: 3 computed';

      expect(results.toString(), equals(strResult));
    });

    test('Making sure that NonlinearResults can be properly compared.', () {
      const results2 = NonlinearResults(
        guesses: [1.0, 2.0, 3.0],
        convergence: 10,
        efficiency: -7,
      );

      expect(results2 == results, isTrue);
      expect(
        results ==
            const NonlinearResults(
              guesses: [1.0, 2.0, 3.0],
              convergence: 10,
              efficiency: -7,
            ),
        isTrue,
      );
      expect(results == results2, isTrue);
      expect(
        const NonlinearResults(
              guesses: [1.0, 2.0, 3.0],
              convergence: 10,
              efficiency: -7,
            ) ==
            results,
        isTrue,
      );
      expect(
        const NonlinearResults(
              guesses: [1.0, 2.0, 3.1],
              convergence: 10,
              efficiency: -7,
            ) ==
            results,
        isFalse,
      );

      expect(
        results.hashCode,
        equals(const NonlinearResults(
          guesses: [1.0, 2.0, 3.0],
          convergence: 10,
          efficiency: -7,
        ).hashCode),
      );

      expect(
        results ==
            const NonlinearResults(
              guesses: [1.0, 2.0],
              convergence: 10,
              efficiency: -7,
            ),
        isFalse,
      );

      expect(
        results ==
            const NonlinearResults(
              guesses: [1.0, 2.0, 5.0],
              convergence: 10,
              efficiency: -7,
            ),
        isFalse,
      );

      expect(
        results ==
            const NonlinearResults(
              guesses: [1.0, 2.0, 3.0],
              convergence: 10,
              efficiency: 7,
            ),
        isFalse,
      );

      expect(
        results ==
            const NonlinearResults(
              guesses: [1.0, 2.0, 3.0],
              convergence: 0,
              efficiency: 0,
            ),
        isFalse,
      );
    });
  });
}
