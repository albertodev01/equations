import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the correctness of exception objects", () {
    test("Making sure that equality comparison works for exception objects",
        () {
      const complexException = ComplexException("Message");
      const algebraicException = AlgebraicException("Message");

      // Objects comparisons
      expect(complexException, equals(const ComplexException("Message")));
      expect(algebraicException, equals(const AlgebraicException("Message")));

      // Checking types
      expect(complexException, isNot(algebraicException));

      // Explicit boolean comparison
      expect(complexException == ComplexException("Message"), isTrue);
      expect(algebraicException == AlgebraicException("Message"), isTrue);

      // Checking hash codes
      expect(complexException.hashCode,
          equals(ComplexException("Message").hashCode));
      expect(algebraicException.hashCode,
          equals(AlgebraicException("Message").hashCode));
    });

    test("Making sure that 'FractionException' prints the correct message", () {
      const exception = ComplexException("Exception message");

      expect(exception.message, equals("Exception message"));
      expect("$exception", equals("ComplexException: Exception message"));
    });

    test("Making sure that 'MixedFractionException' prints the correct message",
        () {
      const exception = AlgebraicException("Exception message");

      expect(exception.message, "Exception message");
      expect("$exception", equals("AlgebraicException: Exception message"));
    });
  });
}
