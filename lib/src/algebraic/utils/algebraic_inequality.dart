import 'package:equations/equations.dart';

/// {@template algebraic_inequality_type}
/// The kind of [Algebraic] inequality to solve.
/// {@endtemplate}
enum AlgebraicInequalityType {
  /// The inequality in the form _P(x) < 0_.
  lessThan,

  /// The inequality in the form _P(x) <= 0_.
  lessThanOrEqualTo,

  /// The inequality in the form _P(x) > 0_.
  greaterThan,

  /// The inequality in the form _P(x) >= 0_.
  greaterThanOrEqualTo,
}

/// {@template algebraic_inequality_solution}
/// A solution of an [Algebraic] inequality.
/// {@endtemplate}
sealed class AlgebraicInequalitySolution {
  /// {@macro algebraic_inequality_solution}
  const AlgebraicInequalitySolution({required this.isInclusive});

  /// Whether the inequality solution is inclusive of the boundaries or not.
  final bool isInclusive;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is AlgebraicInequalitySolution) {
      return runtimeType == other.runtimeType &&
          isInclusive == other.isInclusive;
    }

    return false;
  }

  @override
  int get hashCode => isInclusive.hashCode;
}

/// {@template algebraic_inequality_interval}
/// A solution of an [Algebraic] inequality that is an interval between [start]
/// and [end] values.
/// {@endtemplate}
class AlgebraicInequalityInterval extends AlgebraicInequalitySolution {
  /// The start of the interval.
  final double start;

  /// The end of the interval.
  final double end;

  /// {@macro algebraic_inequality_interval}
  const AlgebraicInequalityInterval({
    required this.start,
    required this.end,
    required super.isInclusive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is AlgebraicInequalityInterval) {
      return runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          isInclusive == other.isInclusive;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(start, end, isInclusive);

  @override
  String toString() =>
      'Interval(start: $start, end: $end, isInclusive: $isInclusive)';
}

/// {@template algebraic_inequality_smaller_than}
/// A solution of an [Algebraic] inequality that is smaller than [value].
/// {@endtemplate}
class AlgebraicInequalitySmallerThan extends AlgebraicInequalitySolution {
  /// The value.
  final double value;

  /// {@macro algebraic_inequality_smaller_than}
  const AlgebraicInequalitySmallerThan({
    required this.value,
    required super.isInclusive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is AlgebraicInequalitySmallerThan) {
      return runtimeType == other.runtimeType &&
          value == other.value &&
          isInclusive == other.isInclusive;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(value, isInclusive);

  @override
  String toString() => 'SmallerThan(value: $value, isInclusive: $isInclusive)';
}

/// {@template algebraic_inequality_greater_than}
/// A solution of an [Algebraic] inequality that is greater than [value].
/// {@endtemplate}
class AlgebraicInequalityGreaterThan extends AlgebraicInequalitySolution {
  /// The value.
  final double value;

  /// {@macro algebraic_inequality_greater_than}
  const AlgebraicInequalityGreaterThan({
    required this.value,
    required super.isInclusive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is AlgebraicInequalityGreaterThan) {
      return runtimeType == other.runtimeType &&
          value == other.value &&
          isInclusive == other.isInclusive;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(value, isInclusive);

  @override
  String toString() => 'GreaterThan(value: $value, isInclusive: $isInclusive)';
}

/// {@template algebraic_inequality_all_real_numbers}
/// A solution of an [Algebraic] inequality that includes all real numbers.
/// {@endtemplate}
class AlgebraicInequalityAllRealNumbers extends AlgebraicInequalitySolution {
  /// {@macro algebraic_inequality_all_real_numbers}
  const AlgebraicInequalityAllRealNumbers() : super(isInclusive: true);

  @override
  String toString() => 'AllRealNumbers(isInclusive: $isInclusive)';
}
