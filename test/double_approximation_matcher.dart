import 'package:test/test.dart';

/// A [Matcher] used to compare two [double]s value within some tolerated error.
///
/// Comparing floating point values using `operator==` can fail due to precision
/// loss given by floating point arithmetics.
///
/// This matcher makes sure that at least the first [precision] digits of the
/// tested value are equal.
class MoreOrLessEquals extends Matcher {
  /// The value to be tested
  final double value;

  /// The accuracy of the test
  final double precision;
  const MoreOrLessEquals(
    this.value, {
    this.precision = 1.0e-12,
  }) : assert(precision >= 0, 'The precision must be >= 0');

  @override
  bool matches(object, Map<dynamic, dynamic> matchState) {
    if (object is double) {
      return (object - value).abs() <= precision;
    }

    return object == value;
  }

  @override
  Description describe(Description description) =>
      description.add('$value (±$precision)');

  @override
  Description describeMismatch(
    item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) =>
      super.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      )..add('$item is not in the range of $value (±$precision).');
}
