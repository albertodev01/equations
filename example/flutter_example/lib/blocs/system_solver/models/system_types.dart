/// Represents kind of system solvers that a bloc has to to handle.
enum SystemType {
  /// Row reduction algorithm.
  rowReduction,

  /// Factorization algorithms like LU or Cholesky.
  factorization,

  /// Algorithms that require initial values and a finite number of steps.
  iterative,
}

/// Row reduction algorithm to solve systems of equations.
enum RowReductionMethods {
  /// Gauss elimination.
  gauss,
}

/// Factorization algorithm factor a matrix into multiple matrices.
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
