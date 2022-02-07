import 'dart:convert';
import 'dart:io';

import 'package:equation_solver_cli/equation_solver_cli.dart';

/// This class uses standard I/O to process user inputs and prints results to
/// the console.
class Console {
  /// Arguments passed to the console.
  final List<String> args;

  /// Creates a new [Console] instance.
  const Console({
    required this.args,
  });

  /// Reads the input and analyzes a fraction or a mixed fraction.
  void run() {
    stdout.encoding = utf8;

    // Only one argument is expected
    if (args.length == 1) {
      Output output;

      switch (args.first) {
        case '-p':
          output = const PolynomialOutput();
          break;
        default:
          output = const ErrorOutput();
      }

      output.processOutput();
    } else {
      stdout.writeln(
        '\n > Error: exactly one argument is required but ${args.length} have '
        'been provided)\n',
      );
    }

    // To keep the console 'awake'. This is very useful on Windows!
    stdout.write('Press any key to exit...');
    stdin.readLineSync();
  }
}
