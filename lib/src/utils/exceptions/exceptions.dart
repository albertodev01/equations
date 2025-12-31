/// {@template equation_exception}
/// Base class for exception objects in the equations package.
/// {@endtemplate}
abstract class EquationException implements Exception {
  /// The error message.
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

  /// {@macro equation_exception}
  const EquationException({
    required this.message,
    required this.messagePrefix,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is EquationException) {
      return runtimeType == other.runtimeType &&
          messagePrefix == other.messagePrefix &&
          message == other.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(message, messagePrefix);

  @override
  String toString() => '$messagePrefix: $message';
}
