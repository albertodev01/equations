import 'dart:io';

/// Abstract type that exposes a method to print to [stdout].
abstract class Output {
  /// Allows subclasses to have a 'const' constructor.
  const Output();

  /// Prints to the console, using [stdout], some examples of equations, systems
  /// of equations, or integrals solved using various algorithms.
  void processOutput();
}
