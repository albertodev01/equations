import 'package:equatable/equatable.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';

/// Events for the [NonlinearBloc] bloc.
abstract class NonlinearEvent extends Equatable {
  /// The maximum number of iterations possible
  final int maxIterations;

  /// The precision of the algorithm
  final double precision;

  /// Initializes a [NonlinearEvent] instance.
  const NonlinearEvent({
    required this.maxIterations,
    required this.precision,
  });

  @override
  List<Object?> get props => [
        maxIterations,
        precision,
      ];
}

/// Event fired when the bloc has to solve an equation using a root finding
/// algorithm that requires a single starting point.
class SinglePointMethod extends NonlinearEvent {
  /// The real function `f(x)`
  final String function;

  /// The 'raw' string representing the initial guess, which may be a fraction
  /// or a integer/floating point number.
  final String initialGuess;

  /// The method to be used to find the root
  final SinglePointMethods method;

  /// Requires the coefficients of the polynomial to be solved.
  const SinglePointMethod({
    required this.function,
    required this.initialGuess,
    required this.method,
    int maxIterations = 15,
    double precision = 1.0e-10,
  }) : super(
          maxIterations: maxIterations,
          precision: precision,
        );

  @override
  List<Object?> get props => [
        function,
        initialGuess,
        method,
        maxIterations,
        precision,
      ];

  /// Tries to return a [SinglePointMethods] value from a string value.
  static SinglePointMethods resolve(String name) {
    if (name.toLowerCase() == 'newton') {
      return SinglePointMethods.newton;
    }

    if (name.toLowerCase() == 'steffensen') {
      return SinglePointMethods.steffensen;
    }

    throw ArgumentError("The given string doesn't map to a valid "
        'SinglePointMethods value.');
  }
}

/// Event fired when the bloc has to solve an equation using a root finding
/// algorithm that brackets the root
class BracketingMethod extends NonlinearEvent {
  /// The real function `f(x)`
  final String function;

  /// The 'raw' string representing the lower bound, which may be a fraction
  /// or a integer/floating point number.
  final String lowerBound;

  /// The 'raw' string representing the upper bound, which may be a fraction
  /// or a integer/floating point number.
  final String upperBound;

  /// The method to be used to find the root
  final BracketingMethods method;

  /// Requires the coefficients of the polynomial to be solved.
  const BracketingMethod(
      {required this.function,
      required this.lowerBound,
      required this.upperBound,
      required this.method,
      int maxIterations = 15,
      double precision = 1.0e-10})
      : super(
          maxIterations: maxIterations,
          precision: precision,
        );

  @override
  List<Object?> get props => [
        function,
        lowerBound,
        upperBound,
        method,
        maxIterations,
        precision,
      ];

  /// Tries to return a [BracketingMethods] value from a string value.
  static BracketingMethods resolve(String name) {
    if (name.toLowerCase() == 'secant') {
      return BracketingMethods.secant;
    }

    if (name.toLowerCase() == 'brent') {
      return BracketingMethods.brent;
    }

    if (name.toLowerCase() == 'bisection') {
      return BracketingMethods.bisection;
    }

    throw ArgumentError("The given string doesn't map to a valid "
        'BracketingMethods value.');
  }
}

/// Event fired when the state of the bloc has to be "resetted". This is generally
/// used to clean the UI and bring it to an initial state.
class NonlinearClean extends NonlinearEvent {
  /// Instantiates a [NonlinearClean] event.
  const NonlinearClean()
      : super(
          maxIterations: 0,
          precision: 0,
        );
}
