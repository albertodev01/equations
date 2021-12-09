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

  /// Whether the matrix is diagonal or not.
  final bool isDiagonal;

  /// Whether the matrix is symmetric or not.
  final bool isSymmetric;

  /// Whether it's an identity matrix or not.
  final bool isIdentity;

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
    required this.isDiagonal,
    required this.isSymmetric,
    required this.isIdentity,
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
        isDiagonal,
        isSymmetric,
        isIdentity,
      ];
}

/// State emitted when the complex number has been analyzed and results are
/// available.
class AnalyzedComplexNumber extends OtherState {
  /// The polar representation of the complex number.
  final PolarComplex polarComplex;

  /// The complex conjugate.
  final Complex conjugate;

  /// The complex reciprocal.
  final Complex reciprocal;

  /// The modulus/aboslute value.
  final double abs;

  /// The square root of the complex number.
  final Complex sqrt;

  /// The phase.
  final double phase;

  /// Creates an [AnalyzedComplexNumber] object..
  const AnalyzedComplexNumber({
    required this.polarComplex,
    required this.conjugate,
    required this.reciprocal,
    required this.abs,
    required this.sqrt,
    required this.phase,
  });

  @override
  List<Object?> get props => [
        polarComplex,
        conjugate,
        reciprocal,
        abs,
        sqrt,
        phase,
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
