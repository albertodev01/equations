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

/// Event fired when there's a complex number to be analyzed.
class ComplexNumberAnalyze extends OtherEvent {
  /// The real part.
  final String realPart;

  /// The imaginary part
  final String imaginaryPart;

  /// Requires the real and imaginary part of the complex number to be analyzed.
  const ComplexNumberAnalyze({
    required this.realPart,
    required this.imaginaryPart,
  });

  @override
  List<Object?> get props => [
        realPart,
        imaginaryPart,
      ];
}

/// Event fired when the state of the bloc has to be "reset". This is generally
/// used to clean the UI and bring it to an initial state.
class OtherClean extends OtherEvent {
  /// Instantiates an [OtherClean] event.
  const OtherClean();
}
