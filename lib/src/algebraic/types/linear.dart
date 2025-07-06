part of '../algebraic.dart';

/// {@template linear_algebraic}
/// Concrete implementation of [Algebraic] that represents a first degree
/// polynomial equation in the form _ax + b = 0_.
///
/// This equation has exactly 1 solution, which can be real or complex.
/// {@endtemplate}
///
/// {@template linear_algebraic_examples}
/// These are examples of linear equations, where the coefficient with the
/// highest degree goes first:
///
/// ```dart
/// // f(x) = 2x + 5
/// final eq = Linear(
///   a: Complex.fromReal(2),
///   b: Complex.fromReal(5),
/// );
///
/// // f(x) = (3 + i)x + 6
/// final eq = Linear(
///   a: Complex(3, 1),
///   b: Complex.fromReal(6),
/// );
///
/// // f(x) = 2x + 5
/// final eq = Linear.realEquation(
///   a: 2,
///   b: 5,
/// );
///
/// // f(x) = 3 - x
/// final eq = Linear.realEquation(
///   a: -1,
///   b: 3,
/// );
/// ```
/// {@endtemplate}
final class Linear extends Algebraic {
  /// {@macro linear_algebraic}
  ///
  /// {@macro linear_algebraic_examples}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, then consider using [Linear.realEquation] for a
  /// less verbose syntax.
  Linear({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
  }) : super([a, b]);

  /// {@macro linear_algebraic}
  ///
  /// {@macro linear_algebraic_examples}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Linear.new] constructor instead.
  Linear.realEquation({double a = 1, double b = 0})
    : super.realEquation([a, b]);

  @override
  int get degree => 1;

  @override
  Algebraic derivative() => Constant(a: a);

  @override
  Complex discriminant() => const Complex.fromReal(1);

  @override
  List<Complex> solutions() => [b.negate / a];

  /// {@macro algebraic_deep_copy}
  Linear copyWith({Complex? a, Complex? b}) =>
      Linear(a: a ?? this.a, b: b ?? this.b);

  /// {@macro first_coefficient_algebraic}
  /// _f(x) = ax + b_.
  Complex get a => coefficients.first;

  /// {@macro second_coefficient_algebraic}
  /// _f(x) = ax + b_.
  Complex get b => coefficients[1];
}
