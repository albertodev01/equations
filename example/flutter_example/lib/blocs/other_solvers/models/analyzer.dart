import 'package:equatable/equatable.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';

/// Analyzes a certain data type and returns a series of results.
abstract class Analyzer<T extends OtherState> extends Equatable {
  /// This is required to parse the coefficients received from the user as 'raw'
  /// strings.
  static const _parser = ExpressionParser();

  /// Creates an [Analyzer] instance.
  const Analyzer();

  /// Converts a list of [String] into a list of [double].
  ///
  /// Throws if a string doesn't represent a valid fraction or number.
  List<double> valuesParser(List<String> source) {
    return source.map(_parser.evaluate).toList();
  }

  /// Converts a [String] into a [double].
  ///
  /// Throws if the string doesn't represent a valid fraction or number.
  double valueParser(String source) {
    return _parser.evaluate(source);
  }

  /// Processes the input and returns the results of the analysis
  T process();
}
