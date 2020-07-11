import 'package:equations/src/nonlinear/nonlinear.dart';

/// Exception object thrown by [Complex]
class ComplexException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Complex] class
  const ComplexException(this.message);

  @override
  String toString() => "ComplexException: $message";
}

/// Exception object thrown by [Complex]
class AlgebraicException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Complex] class
  const AlgebraicException(this.message);

  @override
  String toString() => "AlgebraicException: $message";
}

/// Exception object thrown by [NonLinear]
class NonlinearException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Complex] class
  const NonlinearException(this.message);

  @override
  String toString() => "AlgebraicException: $message";
}