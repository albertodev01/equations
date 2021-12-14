import 'package:equatable/equatable.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';

/// Events for the [IntegralBloc] bloc.
abstract class IntegralEvent extends Equatable {
  /// Creates an [IntegralEvent] instance.
  const IntegralEvent();

  @override
  List<Object?> get props => [];
}

/// Event fired when the bloc has to integrate the function on the given bounds.
class IntegralSolve extends IntegralEvent {
  /// The function to integrate.
  final String function;

  /// The lower integration bound.
  final String lowerBound;

  /// The upper integration bound.
  final String upperBound;

  /// The number of parts in which the interval has to be split by the algorithm.
  final int intervals;

  /// The type of algorithm to be used.
  final IntegralType integralType;

  /// Creates an [IntegralSolve] instance.
  const IntegralSolve({
    required this.function,
    required this.lowerBound,
    required this.upperBound,
    required this.intervals,
    required this.integralType,
  });

  @override
  List<Object?> get props => [
        function,
        lowerBound,
        upperBound,
        intervals,
        integralType,
      ];
}

/// Event fired when the state of the bloc has to be "reset". This is generally
/// used to clean the UI to bring it to an initial state.
class IntegralClean extends IntegralEvent {
  /// Instantiates a [IntegralClean] event.
  const IntegralClean();
}
