import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the contents of a [NonlinearBody] widget by processing
/// the inputs (received as raw strings) and solving nonlinear equations.
class NonlinearBloc extends Bloc<NonlinearEvent, NonlinearState> {
  /// This is required to parse the coefficients received from the user as 'raw'
  /// strings.
  final _parser = const ExpressionParser();

  /// The type root finding algorithm this bloc has to solve.
  final NonlinearType nonlinearType;

  /// Initializes a [NonlinearBloc] with [NonlinearNone].
  NonlinearBloc(this.nonlinearType) : super(const NonlinearNone()) {
    on<NonlinearClean>(_onNonlinearClean);
    on<BracketingMethod>(_onBracketingMethod);
    on<SinglePointMethod>(_onSinglePtMethod);
  }

  void _onBracketingMethod(BracketingMethod evt, Emitter<NonlinearState> emit) {
    try {
      late final NonLinear solver;

      final lower = _parser.evaluate(evt.lowerBound);
      final upper = _parser.evaluate(evt.upperBound);

      switch (evt.method) {
        case BracketingMethods.bisection:
          solver = Bisection(
            function: evt.function,
            a: lower,
            b: upper,
            maxSteps: evt.maxIterations,
            tolerance: evt.precision,
          );
          break;
        case BracketingMethods.secant:
          solver = Secant(
            function: evt.function,
            a: lower,
            b: upper,
            maxSteps: evt.maxIterations,
            tolerance: evt.precision,
          );
          break;
        case BracketingMethods.brent:
          solver = Brent(
            function: evt.function,
            a: lower,
            b: upper,
            maxSteps: evt.maxIterations,
            tolerance: evt.precision,
          );
          break;
      }

      emit(
        NonlinearGuesses(
          nonLinear: solver,
          nonlinearResults: solver.solve(),
        ),
      );
    } on Exception {
      emit(const NonlinearError());
    }
  }

  void _onSinglePtMethod(SinglePointMethod evt, Emitter<NonlinearState> emit) {
    try {
      late final NonLinear solver;
      final x0 = _parser.evaluate(evt.initialGuess);

      switch (evt.method) {
        case SinglePointMethods.newton:
          solver = Newton(
            function: evt.function,
            x0: x0,
            maxSteps: evt.maxIterations,
            tolerance: evt.precision,
          );
          break;
        case SinglePointMethods.steffensen:
          solver = Steffensen(
            function: evt.function,
            x0: x0,
            maxSteps: evt.maxIterations,
            tolerance: evt.precision,
          );
          break;
      }

      emit(
        NonlinearGuesses(
          nonLinear: solver,
          nonlinearResults: solver.solve(),
        ),
      );
    } on Exception {
      emit(const NonlinearError());
    }
  }

  void _onNonlinearClean(_, Emitter<NonlinearState> emit) {
    emit(const NonlinearNone());
  }
}
