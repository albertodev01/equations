import 'package:equatable/equatable.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';

/// Events for the [OtherBloc] bloc.
abstract class OtherEvent extends Equatable {
  /// Initializes a [PolynomialEvent].
  const OtherEvent();

  @override
  List<Object?> get props => [];
}

/// Event fired when there's a matrix to be analyzed.
class MatrixAnalyze extends OtherEvent {
  /// A list of 'raw' strings representing the elements of the matrix.
  final List<String> matrix;

  /// The size of the square matrix.
  final int size;

  /// Requires the coefficients matrix and its size.
  const MatrixAnalyze({
    required this.matrix,
    required this.size,
  });

  @override
  List<Object?> get props => [
        matrix,
        size,
      ];
}

/// Event fired when there's a polynomial to be analyzed.
class PolynomialAnalyze extends OtherEvent {
  /// The coefficients of the polynomial.
  final List<String> coefficients;

  /// Requires the coefficients of the polynomial to be analyzed.
  const PolynomialAnalyze({
    required this.coefficients,
  });

  @override
  List<Object?> get props => [
        coefficients,
      ];
}

/// Event fired when the state of the bloc has to be "reset". This is generally
/// used to clean the UI and bring it to an initial state.
class OtherClean extends OtherEvent {
  /// Instantiates an [OtherClean] event.
  const OtherClean();
}
