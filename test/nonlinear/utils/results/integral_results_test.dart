import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  late final IntegralResults results;

  setUpAll(() {
    results = const IntegralResults(guesses: [1.0, 2.0, 3.0], result: 5.28);
  });

  group('Testing the behaviors of the IntegralResults class.', () {
    test('Making that IntegralResults values are properly constructed.', () {
      expect(results.guesses, orderedEquals(<double>[1.0, 2.0, 3.0]));
      expect(results.result, equals(5.28));
    });

    test('Making sure that "IntegralResults" overrides "toString()".', () {
      const strResult = 'Result: 5.28\nGuesses: 3 computed';

      expect(results.toString(), equals(strResult));
    });

    test('Making sure that IntegralResults can be properly compared.', () {
      const results2 = IntegralResults(
        guesses: [1.0, 2.0, 3.0],
        result: 5.28,
      );

      expect(results2 == results, isTrue);
      expect(
        results ==
            const IntegralResults(
              guesses: [1.0, 2.0, 3.0],
              result: 5.28,
            ),
        isTrue,
      );
      expect(results == results2, isTrue);
      expect(
        const IntegralResults(
              guesses: [1.0, 2.0, 3.0],
              result: 5.28,
            ) ==
            results,
        isTrue,
      );

      expect(
        results.hashCode,
        equals(
          const IntegralResults(
            guesses: [1.0, 2.0, 3.0],
            result: 5.28,
          ).hashCode,
        ),
      );

      expect(
        const IntegralResults(
              guesses: [1.0, 2.001, 3.0],
              result: 5.28,
            ) ==
            results,
        isFalse,
      );
      expect(
        results ==
            const IntegralResults(
              guesses: [1.0, 2.0],
              result: 5.28,
            ),
        isFalse,
      );

      expect(
        results ==
            const IntegralResults(
              guesses: [1.0, 2.0, 5.0],
              result: 5.28,
            ),
        isFalse,
      );

      expect(
        results ==
            const IntegralResults(
              guesses: [1.0, 2.0, 3.0],
              result: 6,
            ),
        isFalse,
      );
    });
  });
}
