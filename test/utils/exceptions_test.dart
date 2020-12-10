import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the correctness of exception objects", () {
    test("Making sure that equality comparison works for exception objects",
        () {
      const complexException = ComplexException("Message");
      const algebraicException = AlgebraicException("Message");
      const nonlinearException = NonlinearException("Message");
      const parserException = ExpressionParserException("Message");

      // Objects comparisons
      expect(complexException, equals(const ComplexException("Message")));
      expect(algebraicException, equals(const AlgebraicException("Message")));
      expect(nonlinearException, equals(const NonlinearException("Message")));
      expect(parserException, equals(const ExpressionParserException("Message")));

      // Checking types
      expect(complexException, isNot(algebraicException));
      expect(algebraicException, isNot(nonlinearException));
      expect(nonlinearException, isNot(parserException));

      // Explicit boolean comparison
      expect(complexException == ComplexException("Message"), isTrue);
      expect(algebraicException == AlgebraicException("Message"), isTrue);
      expect(nonlinearException == NonlinearException("Message"), isTrue);
      expect(parserException == ExpressionParserException("Message"), isTrue);

      // Checking hash codes
      expect(complexException.hashCode,
          equals(ComplexException("Message").hashCode));
      expect(algebraicException.hashCode,
          equals(AlgebraicException("Message").hashCode));
      expect(nonlinearException.hashCode,
          equals(NonlinearException("Message").hashCode));
      expect(parserException.hashCode,
          equals(ExpressionParserException("Message").hashCode));
    });

    test("Making sure that 'ComplexException' prints the correct message", () {
      const exception = ComplexException("Exception message");

      expect(exception.message, equals("Exception message"));
      expect("$exception", equals("ComplexException: Exception message"));
    });

    test("Making sure that 'AlgebraicException' prints the correct message",
        () {
      const exception = AlgebraicException("Exception message");

      expect(exception.message, "Exception message");
      expect("$exception", equals("AlgebraicException: Exception message"));
    });

    test("Making sure that 'NonlinearException' prints the correct message",
        () {
      const exception = NonlinearException("Exception message");

      expect(exception.message, "Exception message");
      expect("$exception", equals("NonlinearException: Exception message"));
    });

    test("Making sure that 'ExpressionParserException' prints the correct message",
        () {
      const exception = ExpressionParserException("Exception message");

      expect(exception.message, "Exception message");
      expect("$exception", equals("ExpressionParserException: Exception message"));
    });
  });
}
