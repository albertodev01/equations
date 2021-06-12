import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the contents of a [SystemBody] widget by processing
/// the inputs (received as raw strings) and solving systems of equations.
class SystemBloc extends Bloc<SystemEvent, SystemState> {
  /// The type system solving algorithm this bloc has to use.
  final SystemType systemType;

  /// This is required to parse the coefficients received from the user as 'raw'
  /// strings.
  final _parser = const ExpressionParser();

  /// Initializes a [NonlinearBloc] with [NonlinearNone].
  SystemBloc(this.systemType) : super(const SystemNone());

  @override
  Stream<SystemState> mapEventToState(SystemEvent event) async* {
    if (event is RowReductionMethod) {
      yield* _rowReductionHandler(event);
    }

    if (event is FactorizationMethod) {
      yield* _factorizationHandler(event);
    }

    if (event is IterativeMethod) {

    }

    if (event is SystemClean) {
      yield* _systemCleanHandler(event);
    }
  }

  List<double> _valueParser(List<String> source) {
    return source.map((value) => _parser.evaluate(value)).toList();
  }

  Stream<SystemState> _rowReductionHandler(RowReductionMethod event) async* {
    try {
      // Parsing the system
      final matrix = _valueParser(event.matrix);
      final vector = _valueParser(event.knownValues);

      final solver = GaussianElimination(
        equations: ,
        constants: vector,
      );
    } on Exception {
      yield const NonlinearError();
    }
  }

  Stream<SystemState> _factorizationHandler(FactorizationMethod event) async* {
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

  Stream<SystemState> _systemCleanHandler(SystemClean evt) async* {
    yield const SystemNone();
  }
}
