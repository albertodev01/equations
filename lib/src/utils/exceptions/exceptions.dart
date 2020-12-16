/// Base class for exception objects to be thrown.
abstract class EquationException implements Exception {
  /// The error message
  final String message;

  /// The prefix to display at the beginning of the error message. When reading
  /// the message of an exception inside a try-catch block (for example), the
  /// output would look like this:
  ///
  /// ```dart
  /// "SomeException: The actual error message"
  /// ```
  ///
  /// In the above example, `SomeException` is defined by this variable and it's
  /// always put before the actual error message.
  final String messagePrefix;

  /// Requires the [message] to be associated to the error object.
  const EquationException({required this.message, required this.messagePrefix});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is EquationException) {
      return runtimeType == other.runtimeType &&
          message == other.message &&
          messagePrefix == other.messagePrefix;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;
    result = 37 * result + message.hashCode;
    result = 37 * result + messagePrefix.hashCode;
    return result;
  }

  @override
  String toString() => "$messagePrefix: $message";
}
