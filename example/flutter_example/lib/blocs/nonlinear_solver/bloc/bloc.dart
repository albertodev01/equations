import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the contents of a [NonlinearBody] widget by processing
/// the inputs (received as raw strings) and solving nonlinear equations.
class NonlinearBloc extends Bloc<NonlinearEvent, NonlinearState> {
  /// The type root finding algorithm this bloc has to solve.
  final NonlinearType nonlinearType;

  /// Initializes a [NonlinearBloc] with [NonlinearNone].
  NonlinearBloc(this.nonlinearType) : super(const NonlinearNone());

  @override
  Stream<NonlinearState> mapEventToState(NonlinearEvent event) async* {
    if (event is SinglePointMethod) {
      yield* _nonlinearSinglePointHandler(event);
    }

    if (event is BracketingMethod) {
      yield* _bracketingHandlerHandler(event);
    }

    if (event is NonlinearClean) {
      yield* _nonlinearCleanHandler(event);
    }
  }

  /// Converts a [String] into a [Fraction] and throws if the conversion fails.
  double _parseDouble(String value) => Fraction.fromString(value).toDouble();

  Stream<NonlinearState> _nonlinearSinglePointHandler(
      SinglePointMethod evt) async* {
    try {
      late final NonLinear solver;
      final x0 = _parseDouble(evt.initialGuess);

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

      yield NonlinearGuesses(
        nonLinear: solver,
        nonlinearResults: solver.solve(),
      );
    } on Exception {
      yield const NonlinearError();
    }
  }

  Stream<NonlinearState> _bracketingHandlerHandler(
      BracketingMethod evt) async* {
    try {
      late final NonLinear solver;

      final lower = _parseDouble(evt.lowerBound);
      final upper = _parseDouble(evt.upperBound);

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
            firstGuess: lower,
            secondGuess: upper,
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

      yield NonlinearGuesses(
        nonLinear: solver,
        nonlinearResults: solver.solve(),
      );
    } on Exception {
      yield const NonlinearError();
    }
  }

  Stream<NonlinearState> _nonlinearCleanHandler(NonlinearClean evt) async* {
    yield const NonlinearNone();
  }
}
