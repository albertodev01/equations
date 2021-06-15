import 'package:equatable/equatable.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';

/// Events for the [NonlinearBloc] bloc.
abstract class SystemEvent extends Equatable {
  /// A list of 'raw' strings representing the elements of the matrix
  final List<String> matrix;

  /// A list of 'raw' strings representing the known values vector
  final List<String> knownValues;

  /// The size of the square matrix.
  final int size;

  /// Initializes a [NonlinearEvent] instance.
  const SystemEvent({
    required this.matrix,
    required this.knownValues,
    required this.size,
  });

  @override
  List<Object?> get props => [matrix, knownValues, size];
}

/// Event fired when the bloc has to solve a system with the Gaussian elimination
/// procedure.
class RowReductionMethod extends SystemEvent {
  /// Creates a [RowReductionMethod] type.
  const RowReductionMethod({
    required List<String> matrix,
    required List<String> knownValues,
    required int size,
  }) : super(
          matrix: matrix,
          knownValues: knownValues,
          size: size,
        );

  /// Tries to return a [RowReductionMethods] value from a string value.
  static RowReductionMethods resolve(String name) {
    if (name.toLowerCase() == 'gauss') {
      return RowReductionMethods.gauss;
    }

    throw ArgumentError("The given string doesn't map to a valid "
        'RowReductionMethods value.');
  }
}

/// Event fired when the bloc has to solve a system using a factorization method
/// (such as LU or Cholesky).
class FactorizationMethod extends SystemEvent {
  /// The method to be used to find the solution vector.
  final FactorizationMethods method;

  /// Creates a [FactorizationMethod] type.
  const FactorizationMethod({
    required List<String> matrix,
    required List<String> knownValues,
    required int size,
    this.method = FactorizationMethods.lu,
  }) : super(
          matrix: matrix,
          knownValues: knownValues,
          size: size,
        );

  @override
  List<Object?> get props => [
        matrix,
        knownValues,
        size,
        method,
      ];

  /// Tries to return a [FactorizationMethods] value from a string value.
  static FactorizationMethods resolve(String name) {
    if (name.toLowerCase() == 'lu') {
      return FactorizationMethods.lu;
    }

    if (name.toLowerCase() == 'cholesky') {
      return FactorizationMethods.cholesky;
    }

    throw ArgumentError("The given string doesn't map to a valid "
        'FactorizationMethods value.');
  }
}

/// Event fired when the bloc has to solve a system using an iterative method
/// (such as Jacobi or SOR).
class IterativeMethod extends SystemEvent {
  /// The method to be used to find the solution vector.
  final IterativeMethods method;

  /// The maximum number of iterations to be made by the algorithm.
  final int maxSteps;

  /// The accuracy of the algorithm
  final double precision;

  /// The relaxation value `w`, which is only used when [IterativeMethods.sor]
  /// is used.
  final double w;

  /// Creates a [FactorizationMethod] type.
  const IterativeMethod({
    required List<String> matrix,
    required List<String> knownValues,
    required int size,
    this.method = IterativeMethods.sor,
    this.w = 1,
    this.precision = 1.0e-10,
    this.maxSteps = 20,
  }) : super(
          matrix: matrix,
          knownValues: knownValues,
          size: size,
        );

  @override
  List<Object?> get props => [
        matrix,
        knownValues,
        size,
        method,
      ];

  /// Tries to return a [IterativeMethods] value from a string value.
  static IterativeMethods resolve(String name) {
    if (name.toLowerCase() == 'sor') {
      return IterativeMethods.sor;
    }

    if (name.toLowerCase() == 'jacobi') {
      return IterativeMethods.jacobi;
    }

    throw ArgumentError("The given string doesn't map to a valid "
        'IterativeMethods value.');
  }
}

/// Event fired when the state of the bloc has to be "resetted". This is  used
/// to clean the UI and bring it to an initial state.
class SystemClean extends SystemEvent {
  /// Instantiates a [SystemEvent] event.
  const SystemClean()
      : super(
          matrix: const [],
          knownValues: const [],
          size: 0,
        );
}
