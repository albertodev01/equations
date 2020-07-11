import 'package:equations/src/algebraic/algebraic.dart';
import 'package:equations/src/algebraic/linear.dart';
import 'package:equations/src/complex.dart';

/// Concrete implementation of [Algebraic] that represents a second degree
/// polynomial equation in the form _ax^2 + bx + c = 0_.
///
/// This equation has exactly 2 roots, both real or both complex, depending
/// on the value of the discriminant.
class Quadratic extends Algebraic {

  /// The first coefficient of the equation in the form _f(x) = ax^2 + bx + c = 0_
  final Complex a;

  /// The second coefficient of the equation in the form _f(x) = ax^2 + bx + c = 0_
  final Complex b;

  /// The third coefficient of the equation in the form _f(x) = ax^2 + bx + c = 0_
  final Complex c;

  /// This is an example of a quadratic equation, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = x^2 - 6x + 5
  /// final eq = Quadratic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(-6),
  ///   c: Complex.fromReal(5),
  /// );
  ///
  /// // f(x) = ix^2 - 3
  /// final eq = Quadratic(
  ///   a: Complex.fromImaginary(1),
  ///   c: Complex.fromReal(-3),
  /// );
  /// ```
  Quadratic({
    this.a = const Complex.fromReal(1),
    this.b = const Complex.zero(),
    this.c = const Complex.zero(),
  }) : super([a, b, c]);

  @override
  int get degree => 2;

  @override
  Algebraic derivative() => Linear(
    a: a * Complex.fromReal(2),
    b: b,
  );

  @override
  Complex discriminant() {
    final root = Complex.fromReal(4) * a * c;
    return (b * b) - root;
  }

  @override
  List<Complex> solutions() {
    final disc = discriminant();
    final twoA = Complex.fromReal(2) * a;

    return <Complex>[
      (b.negate + disc.sqrt) / twoA,
      (b.negate - disc.sqrt) / twoA,
    ];
  }

}