/// Holds a series of results returned by [NonLinear.solve]:
///
///  - the list of guesses computed by the algorithm,
///  - the rate of convergence (if possible),
///  - the efficiency of the algorithm (if possible).
class NonlinearResults {
  /// List of values guessed by the algorithm.
  final List<double> guesses;

  /// The rate of convergence.
  final double convergence;

  /// The efficiency of the algorithm.
  final double efficiency;

  /// [guesses] is the scalar succession built by the algorithm, [convergence]
  /// represents the rate of convergence and [efficiency] is the efficiency of
  /// the algorithm expressed as _p = convergence <sup>1 / max_steps</sup>_.
  const NonlinearResults({
    required this.guesses,
    required this.convergence,
    required this.efficiency,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is NonlinearResults) {
      // The lengths of the coefficients must match
      if (guesses.length != other.guesses.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the
      // coefficients list.
      var equalsCount = 0;

      for (var i = 0; i < guesses.length; ++i) {
        if (guesses[i] == other.guesses[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == guesses.length &&
          convergence == other.convergence &&
          efficiency == other.efficiency;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 2011;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < guesses.length; ++i) {
      result = result * 37 + guesses[i].hashCode;
    }

    result = result * 37 + convergence.hashCode;
    result = result * 37 + efficiency.hashCode;

    return result;
  }

  @override
  String toString() {
    final sb = StringBuffer()
      ..write('Convergence rate: ')
      ..writeln(convergence)
      ..write('Efficiency: ')
      ..writeln(efficiency)
      ..write('Guesses: ')
      ..write(guesses.length)
      ..write(' computed');

    return sb.toString();
  }
}
