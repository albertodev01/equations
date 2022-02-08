import 'package:equation_solver_cli/equation_solver_cli.dart'
    as equation_solver_cli;

/// The main entrypoint expects only 1 argument, which is used to determine the
/// kind of demo to be run.
void main(List<String> arguments) {
  // Parsing arguments and running the app.
  equation_solver_cli.Console(
    args: arguments,
  ).run();
}
