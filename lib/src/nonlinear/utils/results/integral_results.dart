/// Holds a series of results returned by [NumericalIntegration.integrate]:
///
///  - the list of guesses computed by the algorithm,
///  - the actual result (the value of the integral on an `[a, b]` interval)
class IntegralResults {
  /// List of values guessed by the algorithm
  final List<double> guesses;

  /// The result of the integral on an `[a, b]` interval
  final double result;

  /// The list of [guesses] is iteratively built by the algorithm while the
  /// final [result] is the actual value of the integral in the `[a, b]` interval.
  const IntegralResults({
    required this.guesses,
    required this.result,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is IntegralResults) {
      // The lengths of the coefficients must match
      if (guesses.length != other.guesses.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
      var equalsCount = 0;

      for (var i = 0; i < guesses.length; ++i) {
        if (guesses[i] == other.guesses[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == guesses.length &&
          result == other.result;
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
      result = 37 * result + guesses[i].hashCode;
    }

    return 37 * result + result.hashCode;
  }

  @override
  String toString() {
    final sb = StringBuffer()
      ..write('Result: ')
      ..writeln(result)
      ..write('Guesses: ')
      ..write(guesses.length)
      ..write(' computed');

    return sb.toString();
  }
}
