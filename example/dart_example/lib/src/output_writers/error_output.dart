import 'dart:io';

import 'package:equation_solver_cli/src/output.dart';

/// Prints an error message to the console stating that the given argument is
/// not valid.
class ErrorOutput extends Output {
  /// Creates an [ErrorOutput] object.
  const ErrorOutput();

  @override
  void processOutput() {
    stdout.writeln('\n > Error: the given argument is not valid!\n');
  }
}
