import 'package:equations/equations.dart';
import 'package:equations_solver/routes/system_page.dart';
import 'package:equations_solver/routes/system_page/model/system_result.dart';
import 'package:flutter/widgets.dart';

/// The types of system solving algorithms.
enum SystemType {
  /// Row reduction algorithm.
  rowReduction,

  /// Factorization algorithms like LU or Cholesky.
  factorization,

  /// Algorithms that require initial values and a finite number of steps.
  iterative,
}

/// Row reduction algorithms to solve systems of equations.
enum RowReductionMethods {
  /// Gauss elimination.
  gauss,
}

/// Factorization algorithms that factor a matrix into multiple matrices.
enum FactorizationMethods {
  /// LU decomposition.
  lu,

  /// Cholesky decomposition.
  cholesky,
}

/// Iterative methods use an initial value to generate a sequence of improving
/// approximate solutions for the system.
enum IterativeMethods {
  /// Successive Over Relaxation method.
  sor,

  /// Gauss-Seidel method.
  gaussSeidel,

  /// Jacobi method.
  jacobi,
}

/// Holds the state of the [SystemPage] page.
class SystemState extends ChangeNotifier {
  var _state = const SystemResult();

  /// The kind of system solver algorithm to be used.
  final SystemType systemType;

  /// Creates a [SystemState] object.
  SystemState(this.systemType);

  /// The current state.
  SystemResult get state => _state;

  /// Tries to return a [RowReductionMethods] value from a string value.
  static RowReductionMethods rowReductionResolve(String name) {
    if (name.toLowerCase() == 'gauss') {
      return RowReductionMethods.gauss;
    }

    throw ArgumentError(
      "The given string doesn't map to a valid 'RowReductionMethods value.",
    );
  }

  /// Tries to return a [FactorizationMethods] value from a string value.
  static FactorizationMethods factorizationResolve(String name) {
    if (name.toLowerCase() == 'lu') {
      return FactorizationMethods.lu;
    }

    if (name.toLowerCase() == 'cholesky') {
      return FactorizationMethods.cholesky;
    }

    throw ArgumentError(
      "The given string doesn't map to a valid 'FactorizationMethods value.",
    );
  }

  /// Tries to return a [IterativeMethods] value from a string value.
  static IterativeMethods iterativeResolve(String name) {
    if (name.toLowerCase() == 'sor') {
      return IterativeMethods.sor;
    }

    if (name.toLowerCase() == 'jacobi') {
      return IterativeMethods.jacobi;
    }

    throw ArgumentError(
      "The given string doesn't map to a valid 'IterativeMethod value.",
    );
  }

  /// Tries to solve a system of equations using a row reduction algorithm.
  void rowReductionSolver({
    required List<String> flatMatrix,
    required List<String> knownValues,
    required int size,
  }) {
    try {
      final matrix = _valueParser(flatMatrix);
      final vector = _valueParser(knownValues);

      final solver = GaussianElimination(
        matrix: RealMatrix.fromFlattenedData(
          rows: size,
          columns: size,
          data: matrix,
        ),
        knownValues: vector,
      );

      final hasSolution = solver.hasSolution();

      _state = SystemResult(
        systemSolver: hasSolution ? solver : null,
        isSingular: !hasSolution,
      );
    } on Exception {
      _state = const SystemResult();
    }

    notifyListeners();
  }

  /// Tries to solve a system of equations using a factorization algorithm.
  void factorizationSolver({
    required List<String> flatMatrix,
    required List<String> knownValues,
    required int size,
    required FactorizationMethods method,
  }) {
    try {
      final matrix = _valueParser(flatMatrix);
      final vector = _valueParser(knownValues);

      final realMatrix = RealMatrix.fromFlattenedData(
        rows: size,
        columns: size,
        data: matrix,
      );

      final solver = switch (method) {
        FactorizationMethods.lu => LUSolver(
            matrix: realMatrix,
            knownValues: vector,
          ),
        FactorizationMethods.cholesky => CholeskySolver(
            matrix: realMatrix,
            knownValues: vector,
          )
      };

      final hasSolution = solver.hasSolution();

      _state = SystemResult(
        systemSolver: hasSolution ? solver : null,
        isSingular: !hasSolution,
      );
    } on Exception {
      _state = const SystemResult();
    }

    notifyListeners();
  }

  /// Tries to solve a system of equations using an iterative algorithm.
  void iterativeSolver({
    required List<String> flatMatrix,
    required List<String> knownValues,
    required int size,
    required IterativeMethods method,
    String w = '1.25',
    List<String> jacobiInitialVector = const [],
  }) {
    try {
      final matrix = _valueParser(flatMatrix);
      final vector = _valueParser(knownValues);
      const parser = ExpressionParser();

      final realMatrix = RealMatrix.fromFlattenedData(
        rows: size,
        columns: size,
        data: matrix,
      );

      final solver = switch (method) {
        IterativeMethods.sor => SORSolver(
            matrix: realMatrix,
            knownValues: vector,
            w: parser.evaluate(w),
          ),
        IterativeMethods.gaussSeidel => GaussSeidelSolver(
            matrix: realMatrix,
            knownValues: vector,
          ),
        IterativeMethods.jacobi => JacobiSolver(
            matrix: realMatrix,
            knownValues: vector,
            x0: _valueParser(jacobiInitialVector),
          )
      };

      final hasSolution = solver.hasSolution();

      _state = SystemResult(
        systemSolver: hasSolution ? solver : null,
        isSingular: !hasSolution,
      );
    } on Exception {
      _state = const SystemResult();
    }

    notifyListeners();
  }

  /// Clears the state.
  void clear() {
    _state = const SystemResult();
    notifyListeners();
  }

  /// Tries to parse each value of [source] of number and evaluates the
  /// numerical expression.
  List<double> _valueParser(List<String> source) =>
      source.map(const ExpressionParser().evaluate).toList(growable: false);
}
