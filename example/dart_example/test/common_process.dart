import 'dart:io';

/// Creates a new process and parses the command-line argument.
Future<Process> createProcess({String? arg}) => Process.start(
      'dart',
      ['run', './bin/equation_solver_cli.dart', if (arg != null) arg],
    );
