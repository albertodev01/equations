import 'package:equations/equations.dart';

/// Exception object thrown by [Complex]
class ComplexException implements Exception {
  /// Error message
  final String message;

  /// Represents an error for the [Complex] class
  const ComplexException(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is ComplexException) {
      return runtimeType == other.runtimeType && message == other.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;
    result = 37 * result + message.hashCode;
    return result;
  }

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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is AlgebraicException) {
      return runtimeType == other.runtimeType && message == other.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;
    result = 37 * result + message.hashCode;
    return result;
  }

  @override
  String toString() => "AlgebraicException: $message";
}
