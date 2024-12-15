import 'dart:convert';
import 'dart:io';

import 'package:equation_solver_cli/equation_solver_cli.dart';

/// The main entrypoint expects only 1 argument, which is used to determine the
/// kind of demo.
void main(List<String> arguments) {
  stdout.encoding = utf8;

  final output = switch (arguments.firstOrNull) {
    '-p' => const PolynomialOutput(),
    '-n' => const NonlinearOutput(),
    '-i' => const IntegralOutput(),
    '-m' => const MatrixOutput(),
    _ => const ErrorOutput(),
  };

  // Only one argument is expected
  if (arguments.length == 1) {
    output.processOutput();
  } else {
    // Error message when 0 or more than 1 arguments
    stdout.writeln(
      '\n > Error: exactly one argument is required (but ${arguments.length} '
      'have been provided)\n',
    );
  }
}
