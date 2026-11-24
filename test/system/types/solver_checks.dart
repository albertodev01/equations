import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

/// Builds a [SystemSolver] for the `Ax = b` system, where `A` is [matrix] and
/// `b` is [knownValues].
typedef SolverFactory = SystemSolver Function(
  RealMatrix matrix,
  List<double> knownValues, {
  double precision,
});

/// The direct solvers that work with any non-singular matrix.
final generalDirectSolvers = <String, SolverFactory>{
  'GaussianElimination': (matrix, knownValues, {precision = 1.0e-10}) =>
      GaussianElimination(
        matrix: matrix,
        knownValues: knownValues,
        precision: precision,
      ),
  'LUSolver': (matrix, knownValues, {precision = 1.0e-10}) => LUSolver(
    matrix: matrix,
    knownValues: knownValues,
    precision: precision,
  ),
};

/// The iterative solvers, with their default settings.
final iterativeSolvers = <String, SolverFactory>{
  'JacobiSolver': (matrix, knownValues, {precision = 1.0e-10}) => JacobiSolver(
    matrix: matrix,
    knownValues: knownValues,
    precision: precision,
  ),
  'GaussSeidelSolver': (matrix, knownValues, {precision = 1.0e-10}) =>
      GaussSeidelSolver(
        matrix: matrix,
        knownValues: knownValues,
        precision: precision,
      ),
  'SORSolver (w = 1.2)': (matrix, knownValues, {precision = 1.0e-10}) =>
      SORSolver(
        matrix: matrix,
        knownValues: knownValues,
        w: 1.2,
        precision: precision,
      ),
};

/// Every solver. All of them can solve symmetric positive-definite, strictly
/// diagonally dominant systems.
final allSolvers = <String, SolverFactory>{
  ...generalDirectSolvers,
  'CholeskySolver': (matrix, knownValues, {precision = 1.0e-10}) =>
      CholeskySolver(
        matrix: matrix,
        knownValues: knownValues,
        precision: precision,
      ),
  ...iterativeSolvers,
};

/// Builds a [RealMatrix] from a list of rows.
RealMatrix matrixOf(List<List<double>> rows) => RealMatrix.fromData(
  rows: rows.length,
  columns: rows.first.length,
  data: rows,
);

/// A random `n x n` matrix with elements in `[-1, 1]`.
RealMatrix randomMatrix(int n, Random random) => RealMatrix.fromFlattenedData(
  rows: n,
  columns: n,
  data: List<double>.generate(n * n, (_) => 2 * random.nextDouble() - 1),
);

/// A random `n x n` symmetric, strictly diagonally dominant matrix with a
/// positive diagonal. Such a matrix is also positive-definite.
RealMatrix randomDominantSpdMatrix(int n, Random random) {
  final values = List<double>.filled(n * n, 0);
  for (var i = 0; i < n; ++i) {
    for (var j = i + 1; j < n; ++j) {
      final value = 2 * random.nextDouble() - 1;
      values[n * i + j] = value;
      values[n * j + i] = value;
    }
  }

  for (var i = 0; i < n; ++i) {
    final offDiagonal =
        Iterable<int>.generate(
              n,
            )
            .where((j) => j != i)
            .fold<double>(0, (sum, j) => sum + values[n * i + j].abs());
    values[n * i + i] = offDiagonal + 1 + random.nextDouble();
  }

  return RealMatrix.fromFlattenedData(rows: n, columns: n, data: values);
}

/// A random `n x n` symmetric positive-definite matrix that is usually not
/// diagonally dominant: `B^T B + 0.1 I`, where `B` is random.
RealMatrix randomSpdMatrix(int n, Random random) {
  final b = randomMatrix(n, random);
  final values = List<double>.generate(n * n, (k) {
    final i = k ~/ n;
    final j = k % n;
    final product = Iterable<int>.generate(
      n,
    ).fold<double>(0, (sum, r) => sum + b(r, i) * b(r, j));

    return i == j ? product + 0.1 : product;
  });

  return RealMatrix.fromFlattenedData(rows: n, columns: n, data: values);
}

/// The `n x n` Hilbert matrix, whose elements are `1 / (i + j + 1)`. It's
/// symmetric positive-definite and very ill-conditioned.
RealMatrix hilbertMatrix(int n) => RealMatrix.fromFlattenedData(
  rows: n,
  columns: n,
  data: List<double>.generate(n * n, (k) => 1 / (k ~/ n + k % n + 1)),
);

/// The `n x n` tridiagonal matrix with `2` on the diagonal and `-1` next to
/// it (the 1D Poisson matrix). It's symmetric positive-definite but only
/// weakly diagonally dominant, so iterative methods converge slowly.
RealMatrix poissonMatrix(int n) => RealMatrix.fromFlattenedData(
  rows: n,
  columns: n,
  data: List<double>.generate(n * n, (k) {
    final distance = (k ~/ n - k % n).abs();
    return distance == 0 ? 2 : (distance == 1 ? -1 : 0);
  }),
);

/// A random vector of length [n] with elements in `[-10, 10]`.
List<double> randomVector(int n, Random random) =>
    List<double>.generate(n, (_) => 20 * random.nextDouble() - 10);

/// Computes the product `Ax`, where `A` is [matrix].
List<double> multiply(RealMatrix matrix, List<double> x) =>
    List<double>.generate(
      matrix.rowCount,
      (i) => Iterable<int>.generate(
        matrix.columnCount,
      ).fold<double>(0, (sum, j) => sum + matrix(i, j) * x[j]),
    );

/// The largest absolute value in [values].
double maxAbs(Iterable<double> values) =>
    values.fold(0, (current, value) => max(current, value.abs()));

/// Expects [actual] and [expected] to have the same length and elements that
/// differ at most by [tolerance] times `max(1, largest |expected|)`.
void expectVectorClose(
  List<double> actual,
  List<double> expected, {
  double tolerance = 1.0e-8,
}) {
  expect(actual, hasLength(expected.length));

  final limit = tolerance * max(1, maxAbs(expected));
  for (var i = 0; i < expected.length; ++i) {
    expect(
      (actual[i] - expected[i]).abs(),
      lessThanOrEqualTo(limit),
      reason: 'Element $i: expected ${expected[i]}, got ${actual[i]}',
    );
  }
}

/// Expects the residual `||Ax - b||` of [solution] to be small compared to
/// the size of the terms of `Ax`, which is what a backward stable solver
/// guarantees even when the matrix is ill-conditioned.
void expectSmallResidual(
  SystemSolver solver,
  List<double> solution, {
  double tolerance = 1.0e-12,
}) {
  final scale =
      solver.size *
      maxAbs(solver.matrix.flattenData) *
      max(1, maxAbs(solution));

  expect(
    solver.computeResidualNorm(solution),
    lessThanOrEqualTo(tolerance * scale),
  );
}

/// Matches a [SystemSolverException] whose message contains [text].
Matcher throwsSolverException([String text = '']) => throwsA(
  isA<SystemSolverException>().having(
    (e) => e.message,
    'message',
    contains(text),
  ),
);
