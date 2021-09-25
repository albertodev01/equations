import 'package:equatable/equatable.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';

/// States for the [OtherBloc] bloc.
abstract class OtherState extends Equatable {
  /// Initializes a [PolynomialEvent].
  const OtherState();

  @override
  List<Object?> get props => [];
}

/// State emitted when the matrix has been analyzed and results are available.
class AnalyzedMatrix extends OtherState {
  /// The transposed matrix.
  final RealMatrix transpose;

  /// The cofactor matrix.
  final RealMatrix cofactorMatrix;

  /// The inverse matrix.
  final RealMatrix inverse;

  /// The trace of the matrix.
  final double trace;

  /// The rank of the matrix.
  final int rank;

  /// The characteristic polynomial of the matrix.
  final Algebraic characteristicPolynomial;

  /// The eigenvalues of the matrix.
  final List<Complex> eigenvalues;

  /// The determinant of the matrix.
  final double determinant;

  /// Creates an [AnalyzedMatrix] object.
  const AnalyzedMatrix({
    required this.transpose,
    required this.cofactorMatrix,
    required this.inverse,
    required this.trace,
    required this.rank,
    required this.characteristicPolynomial,
    required this.eigenvalues,
    required this.determinant,
  });

  @override
  List<Object?> get props => [
        transpose,
        cofactorMatrix,
        inverse,
        trace,
        rank,
        characteristicPolynomial,
        eigenvalues,
        determinant,
      ];
}

/// State emitted when the polynomial has been analyzed and results are
/// available.
class AnalyzedPolynomial extends OtherState {
  /// The roots of the polynomial.
  final List<Complex> roots;

  /// The derivative of the polynomial.
  final Algebraic derivative;

  /// The discriminant of the polynomial.
  final Complex discriminant;

  /// Requires the coefficients of the polynomial to be analyzed.
  const AnalyzedPolynomial({
    required this.roots,
    required this.derivative,
    required this.discriminant,
  });

  @override
  List<Object?> get props => [
        roots,
        derivative,
        discriminant,
      ];
}

/// This state is emitted to indicate that data is being processed.
class OtherLoading extends OtherState {
  /// Initializes an [OtherLoading] state.
  const OtherLoading();
}

/// This state is emitted when the analyzer failed to process one or more data.
class OtherError extends OtherState {
  /// Initializes an [OtherError] state.
  const OtherError();
}

/// This is an initial state used to "clean" the page bringing it to a default
/// aspect.
class OtherNone extends OtherState {
  /// Initializes an [OtherNone] state.
  const OtherNone();
}
