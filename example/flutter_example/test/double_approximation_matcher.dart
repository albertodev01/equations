import 'package:flutter_test/flutter_test.dart';

/// A [Matcher] used to compare two [double]s value within some tolerated error.
///
/// Comparing floating point values using `operator==` is dangerous since
/// floating point arithmetic is not precise Values close to zero or with too
/// much decimal digits may cause unexpected behaviors.
///
/// This matcher makes sure that at least the first [precision] digits of the
/// tested value are equal.
class MoreOrLessEquals extends Matcher {
  /// The value to be tested
  final double value;

  /// The accuracy of the test
  final double precision;

  /// Matches a value with another using the given [precision].
  const MoreOrLessEquals(
    this.value, {
    this.precision = 1.0e-12,
  }) : assert(precision >= 0, 'The precision must be >= 0');

  @override
  // ignore: avoid-dynamic
  bool matches(
    // ignore: avoid_annotating_with_dynamic
    dynamic object,
    Map<dynamic, dynamic> matchState,
  ) {
    if (object is double) {
      return (object - value).abs() <= precision;
    }

    return object == value;
  }

  @override
  Description describe(Description description) {
    return description.add('$value (±$precision)');
  }

  @override
  Description describeMismatch(
    // ignore: avoid_annotating_with_dynamic
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    return super.describeMismatch(
      item,
      mismatchDescription,
      matchState,
      verbose,
    )..add('$item is not in the range of $value (±$precision).');
  }
}
