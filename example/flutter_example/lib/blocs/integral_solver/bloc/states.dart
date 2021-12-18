import 'package:equatable/equatable.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';

/// States for the [IntegralBloc] bloc.
abstract class IntegralState extends Equatable {
  /// Creates an [IntegralState] instance.
  const IntegralState();

  @override
  List<Object?> get props => [];
}

/// This state is emitted when the solver successfully found the numerical value
/// of the definite integral.
class IntegralResult extends IntegralState {
  /// The result of the integral.
  final double result;

  /// The [NumericalIntegration] object.
  final NumericalIntegration numericalIntegration;

  /// Creates an [IntegralState] instance.
  const IntegralResult({
    required this.result,
    required this.numericalIntegration,
  });

  @override
  List<Object?> get props => [
        result,
        numericalIntegration,
      ];
}

/// This state is emitted when an error occurs while integrating the function
/// (for example, when the function string contains syntax errors).
class IntegralError extends IntegralState {
  /// Creates an [IntegralError] instance.
  const IntegralError();
}

/// Emitted when the state of the bloc has to be "reset". This is generally used
/// to clean the UI to bring it to an initial state.
class IntegralNone extends IntegralState {
  /// Creates an [IntegralNone] instance.
  const IntegralNone();
}
