import 'package:equations/equations.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/result_wrapper.dart';

/// Analyzes a certain data type and returns a series of results.
abstract base class Analyzer<T extends ResultWrapper> {
  /// This is required to parse the coefficients received from the user as 'raw'
  /// strings.
  static const _parser = ExpressionParser();

  /// Creates an [Analyzer] instance.
  const Analyzer();

  /// Converts a list of [String] into a list of [double].
  ///
  /// Throws if one or more strings don't represent a valid fraction or number.
  List<double> valuesParser(List<String> source) {
    return source.map(_parser.evaluate).toList(growable: false);
  }

  /// Converts a [String] into a [double].
  ///
  /// Throws if the string doesn't represent a valid fraction or number.
  double valueParser(String source) => _parser.evaluate(source);

  /// Processes data and returns the result [T] of the analysis.
  T process();
}
