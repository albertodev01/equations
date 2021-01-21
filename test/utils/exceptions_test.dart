import 'package:equations/equations.dart';
import 'package:equations/src/utils/exceptions/types/numerical_integration_exception.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the correctness of exception objects", () {
    test("Making sure that equality comparison works for exception objects",
        () {
      const complexException = ComplexException("Message");
      const algebraicException = AlgebraicException("Message");
      const nonlinearException = NonlinearException("Message");
      const parserException = ExpressionParserException("Message");
      const matrixException = MatrixException("Message");
      const systemException = SystemSolverException("Message");
      const integrationException = NumericalIntegrationException("Message");

      // Objects comparisons
      expect(complexException, equals(const ComplexException("Message")));
      expect(algebraicException, equals(const AlgebraicException("Message")));
      expect(nonlinearException, equals(const NonlinearException("Message")));
      expect(
          parserException, equals(const ExpressionParserException("Message")));
      expect(matrixException, equals(const MatrixException("Message")));
      expect(systemException, equals(const SystemSolverException("Message")));
      expect(integrationException,
          equals(NumericalIntegrationException("Message")));

      // Checking types
      expect(complexException, isNot(algebraicException));
      expect(algebraicException, isNot(nonlinearException));
      expect(nonlinearException, isNot(parserException));
      expect(parserException, isNot(matrixException));
      expect(matrixException, isNot(systemException));
      expect(systemException, isNot(integrationException));

      // Explicit boolean comparison
      expect(complexException == ComplexException("Message"), isTrue);
      expect(algebraicException == AlgebraicException("Message"), isTrue);
      expect(nonlinearException == NonlinearException("Message"), isTrue);
      expect(parserException == ExpressionParserException("Message"), isTrue);
      expect(matrixException == MatrixException("Message"), isTrue);
      expect(systemException == SystemSolverException("Message"), isTrue);
      expect(integrationException == NumericalIntegrationException("Message"),
          isTrue);

      // Checking hash codes
      expect(complexException.hashCode,
          equals(ComplexException("Message").hashCode));
      expect(algebraicException.hashCode,
          equals(AlgebraicException("Message").hashCode));
      expect(nonlinearException.hashCode,
          equals(NonlinearException("Message").hashCode));
      expect(parserException.hashCode,
          equals(ExpressionParserException("Message").hashCode));
      expect(matrixException.hashCode,
          equals(MatrixException("Message").hashCode));
      expect(systemException.hashCode,
          equals(SystemSolverException("Message").hashCode));
      expect(integrationException.hashCode,
          equals(NumericalIntegrationException("Message").hashCode));
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

    test(
        "Making sure that 'ExpressionParserException' prints the correct message",
        () {
      const exception = ExpressionParserException("Exception message");

      expect(exception.message, "Exception message");
      expect(
          "$exception", equals("ExpressionParserException: Exception message"));
    });

    test("Making sure that 'MatrixException' prints the correct message", () {
      const exception = MatrixException("Exception message");

      expect(exception.message, "Exception message");
      expect("$exception", equals("MatrixException: Exception message"));
    });

    test("Making sure that 'SystemSolverException' prints the correct message",
        () {
      const exception = SystemSolverException("Exception message");

      expect(exception.message, "Exception message");
      expect("$exception", equals("SystemSolverException: Exception message"));
    });

    test(
        "Making sure that 'NumericalIntegrationException' prints the correct message",
        () {
      const exception = NumericalIntegrationException("Exception message");

      expect(exception.message, "Exception message");
      expect("$exception",
          equals("NumericalIntegrationException: Exception message"));
    });
  });
}
