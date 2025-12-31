import 'package:equations/equations.dart';

/// {@template system_solver_exception}
/// Exception object thrown by [SystemSolver].
/// {@endtemplate}
class SystemSolverException extends EquationException {
  /// {@macro system_solver_exception}
  const SystemSolverException(String message)
    : super(
        message: message,
        messagePrefix: 'SystemSolverException',
      );
}
