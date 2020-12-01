import 'package:equations/equations.dart';

/// Exception object thrown by [Complex]
class ComplexException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Complex] class
  const ComplexException(this.message);

  @override
  String toString() => "ComplexException: $message";
}

/// Exception object thrown by [Algebraic]
class AlgebraicException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Complex] class
  const AlgebraicException(this.message);

  @override
  String toString() => "AlgebraicException: $message";
}
