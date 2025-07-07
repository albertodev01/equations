import 'package:equations/equations.dart';

/// Exception object thrown by [SystemSolver].
class SystemSolverException extends EquationException {
  /// Represents an exception from the [SystemSolver] class.
  const SystemSolverException(String message)
    : super(
        message: message,
        messagePrefix: 'SystemSolverException',
      );
}
