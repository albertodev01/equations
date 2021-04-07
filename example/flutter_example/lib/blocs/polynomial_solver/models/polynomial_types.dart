import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';

/// Represents the types of polynomials that a [PolynomialBloc] has to to handle.
enum PolynomialType {
  /// A polynomial whose degree is 1.
  linear,

  /// A polynomial whose degree is 2.
  quadratic,

  /// A polynomial whose degree is 3.
  cubic,

  /// A polynomial whose degree is 4.
  quartic,
}
