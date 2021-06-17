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
      yield* _iterativeHandler(event);
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

      final solver = GaussianElimination.flatMatrix(
        equations: matrix,
        constants: vector,
      );

      yield SystemGuesses(
        solution: solver.solve(),
        systemSolver: solver,
      );
    } on Exception {
      yield const SystemError();
    }
  }

  Stream<SystemState> _factorizationHandler(FactorizationMethod event) async* {
    try {
      late final SystemSolver solver;

      // Parsing the system
      final matrix = _valueParser(event.matrix);
      final vector = _valueParser(event.knownValues);

      switch (event.method) {
        case FactorizationMethods.lu:
          solver = LUSolver.flatMatrix(
            equations: matrix,
            constants: vector,
          );
          break;
        case FactorizationMethods.cholesky:
          solver = CholeskySolver.flatMatrix(
            equations: matrix,
            constants: vector,
          );
          break;
      }

      yield SystemGuesses(
        solution: solver.solve(),
        systemSolver: solver,
      );
    } on Exception {
      yield const SystemError();
    }
  }

  Stream<SystemState> _iterativeHandler(IterativeMethod event) async* {
    try {
      late final SystemSolver solver;

      // Parsing the system
      final matrix = _valueParser(event.matrix);
      final vector = _valueParser(event.knownValues);

      switch (event.method) {
        case IterativeMethods.sor:
          solver = SORSolver.flatMatrix(
            equations: matrix,
            constants: vector,
            w: _parser.evaluate(event.w),
          );
          break;
        case IterativeMethods.gaussSeidel:
          solver = GaussSeidelSolver.flatMatrix(
            equations: matrix,
            constants: vector,
          );
          break;
        case IterativeMethods.jacobi:
          solver = JacobiSolver.flatMatrix(
            equations: matrix,
            constants: vector,
            x0: _valueParser(event.jacobiInitialVector),
          );
          break;
      }

      yield SystemGuesses(
        solution: solver.solve(),
        systemSolver: solver,
      );
    } on Exception {
      yield const SystemError();
    }
  }

  Stream<SystemState> _systemCleanHandler(SystemClean evt) async* {
    yield const SystemNone();
  }
}
