import 'dart:io';

import 'package:equation_solver_cli/equation_solver_cli.dart';

/// Creates a new process and parses the [arg] argument using the [Console]
/// class.
Future<Process> createProcess({String? arg}) {
  if (arg != null) {
    return Process.start(
      'dart',
      ['run', './bin/equation_solver_cli.dart', arg],
    );
  } else {
    return Process.start(
      'dart',
      ['run', './bin/equation_solver_cli.dart'],
    );
  }
}
