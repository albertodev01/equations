import 'package:collection/collection.dart';

/// Holds a series of results returned by [NonLinear.solve]:
///
///  - the list of guesses computed by the algorithm,
///  - the rate of convergence (if possible)
///  - the efficiency of the algorithm (if possible)
class NonlinearResults {
  /// List of values guessed by the algorithm
  final List<double> guesses;

  /// The rate of convergence
  final double convergence;

  /// The efficiency of the algorithm
  final double efficiency;

  /// [guessedValues] is the scalar succession built by the algorithm, [convergence]
  /// represents the rate of convergence and [efficiency] is the efficiency of the
  /// algorithm expressed as _p = convergence <sup>1 / max_steps</sup>_.
  NonlinearResults(
      {required List<double> guessedValues,
      required this.convergence,
      required this.efficiency})
      : guesses = List<double>.unmodifiable(guessedValues);

  @override
  bool operator ==(Object other) {
    final compare = const ListEquality<double>().equals;

    return identical(this, other) ||
        other is NonlinearResults &&
            runtimeType == other.runtimeType &&
            compare(guesses, other.guesses) &&
            convergence == other.convergence &&
            efficiency == other.efficiency;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + guesses.hashCode;
    result = 37 * result + convergence.hashCode;
    result = 37 * result + efficiency.hashCode;
    return result;
  }

  @override
  String toString() {
    final sb = StringBuffer()
      ..write("Convergence rate: ")
      ..writeln(convergence)
      ..write("Efficiency: ")
      ..writeln(efficiency)
      ..write("Guesses: ")
      ..write(guesses.length)
      ..write(" computed");

    return sb.toString();
  }
}
