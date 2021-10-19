import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/blocs/integral_solver/models/integral_types.dart';
import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the contents of an [IntegralBody] widget by processing
/// the inputs (received as raw strings) and integrating the function on the
/// given bounds.
class IntegralBloc extends Bloc<IntegralEvent, IntegralState> {
  /// This is required to parse the coefficients received from the user as 'raw'
  /// strings.
  final _parser = const ExpressionParser();

  /// Initializes an [IntegralBloc] with [IntegralNone].
  IntegralBloc() : super(const IntegralNone()) {
    on<IntegralSolve>(_onIntegralSolve);
    on<IntegralClean>(_onIntegralClean);
  }

  void _onIntegralSolve(IntegralSolve event, Emitter<IntegralState> emit) {
    try {
      late final NumericalIntegration integration;

      final lowerBound = _parser.evaluate(event.lowerBound);
      final upperBound = _parser.evaluate(event.upperBound);

      switch (event.integralType) {
        case IntegralType.midPoint:
          integration = MidpointRule(
            function: event.function,
            lowerBound: lowerBound,
            upperBound: upperBound,
            intervals: event.intervals,
          );
          break;
        case IntegralType.simpson:
          integration = SimpsonRule(
            function: event.function,
            lowerBound: lowerBound,
            upperBound: upperBound,
            intervals: event.intervals,
          );
          break;
        case IntegralType.trapezoid:
          integration = TrapezoidalRule(
            function: event.function,
            lowerBound: lowerBound,
            upperBound: upperBound,
            intervals: event.intervals,
          );
          break;
      }

      // Integrating and returning the result
      final integrationResult = integration.integrate();

      emit(
        IntegralResult(
          numericalIntegration: integration,
          result: integrationResult.result,
        ),
      );
    } on Exception {
      emit(
        const IntegralError(),
      );
    }
  }

  void _onIntegralClean(_, Emitter<IntegralState> emit) {
    emit(const IntegralNone());
  }
}
