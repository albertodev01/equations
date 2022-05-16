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

  /// Reads the input and uses [Output] to print to [stdout].
  void run() {
    stdout.encoding = utf8;

    // Only one argument is expected
    if (args.length == 1) {
      Output output;

      switch (args.first) {
        case '-p':
          output = const PolynomialOutput();
          break;
        case '-n':
          output = const NonlinearOutput();
          break;
        case '-i':
          output = const IntegralOutput();
          break;
        case '-m':
          output = const MatrixOutput();
          break;
        default:
          output = const ErrorOutput();
      }

      output.processOutput();
    } else {
      // Error message when 0 or more than 1 arguments are passed
      stdout.writeln(
        '\n > Error: exactly one argument is required but ${args.length} have '
        'been provided)\n',
      );
    }

    // To keep the console 'awake'. This is very useful on Windows!
    stdout.write('Press any key to exit...');

    // This last line is to ensure that the console won't shut down immediately
    // ignore: avoid-ignoring-return-values
    stdin.readLineSync();
  }
}
