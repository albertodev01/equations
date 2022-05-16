import 'package:equatable/equatable.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';

/// Events for the [PolynomialBloc] bloc.
abstract class PolynomialEvent extends Equatable {
  /// The coefficients of the polynomial.
  final List<String> coefficients;

  /// Initializes a [PolynomialEvent] instance.
  const PolynomialEvent({
    this.coefficients = const [],
  });

  @override
  List<Object?> get props => [
        coefficients,
      ];
}

/// Event fired when there's a polynomial equation to be solved.
class PolynomialSolve extends PolynomialEvent {
  /// Requires the coefficients of the polynomial to be solved.
  const PolynomialSolve({
    required super.coefficients,
  });
}

/// Event fired when the state of the bloc has to be "reset". This is generally
/// used to clean the UI and bring it to an initial state.
class PolynomialClean extends PolynomialEvent {
  /// Instantiates a [PolynomialClean] event.
  const PolynomialClean();
}
