import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the behaviors of the NonlinearResults class.", () {
    const results = NonlinearResults(
        guesses: [1.0, 2.0, 3.0], convergence: 10.0, efficiency: -7.0);

    test(("Making that NonlinearResults values are properly constructed."), () {
      expect(results.guesses, orderedEquals(<double>[1.0, 2.0, 3.0]));
      expect(results.convergence, equals(10.0));
      expect(results.efficiency, equals(-7.0));
    });

    test(("Making that NonlinearResults is properly converted into a string."),
        () {
      final strResult = "Convergence rate: 10.0\n"
          "Efficiency: -7.0\n"
          "Guesses: 3 computed";

      expect(results.toString(), equals(strResult));
    });

    test(("Making that NonlinearResults can be properly compared."), () {
      const results2 = NonlinearResults(
          guesses: [1.0, 2.0, 3.0], convergence: 10.0, efficiency: -7.0);

      expect(results2 == results, isTrue);
      expect(
          results ==
              NonlinearResults(
                  guesses: [1.0, 2.0, 3.0],
                  convergence: 10.0,
                  efficiency: -7.0),
          isTrue);

      expect(
          results.hashCode,
          equals(NonlinearResults(
                  guesses: [1.0, 2.0, 3.0], convergence: 10.0, efficiency: -7.0)
              .hashCode));
    });
  });
}
