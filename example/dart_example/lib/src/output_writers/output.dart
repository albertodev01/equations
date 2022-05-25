import 'dart:io';

/// Interface that exposes a method to print to [stdout] some results generated
/// by the 'equations' library.
// ignore: one_member_abstracts
abstract class Output {
  /// Prints to the console, using [stdout], some examples of equations or
  /// systems of equations solved using various algorithms.
  void processOutput();
}
