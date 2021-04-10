import 'package:equatable/equatable.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';

/// States for the [PolynomialBloc] bloc.
abstract class PolynomialState extends Equatable {
  /// The roots of the equation.
  final List<Complex> roots;

  /// The discriminant of the polynomial.
  final Complex discriminant;

  /// Requires the [roots] (solutions) of the equation and the [discriminant].
  const PolynomialState({
    this.roots = const [],
    this.discriminant = const Complex.zero(),
  });

  @override
  List<Object?> get props => [roots, discriminant];
}

/// This state is emitted when the solver successfully finds the roots of the
/// polynomial equation.
class PolynomialRoots extends PolynomialState {
  /// The [Algebraic] object associated to the polynomial being solved.
  final Algebraic algebraic;

  /// Requires the [roots] of the polynomial and the [discriminant].
  const PolynomialRoots({
    required List<Complex> roots,
    required Complex discriminant,
    required this.algebraic,
  }) : super(roots: roots, discriminant: discriminant);

  @override
  List<Object?> get props => [algebraic, roots, discriminant];
}

/// This state is emitted when the solver cannot find the roots of the polynomial
/// equation.
class PolynomialError extends PolynomialState {
  /// Initializes a [PolynomialError]
  const PolynomialError();
}

/// This is an initial state used to "clean" the page bringing it to a default
/// aspect.
class PolynomialNone extends PolynomialState {
  /// Initializes a [PolynomialNone]
  const PolynomialNone();
}
