import 'dart:math' as math;

import 'package:equations/equations.dart';

/// Returns the largest absolute value in [values], or `0` if [values] is
/// empty.
///
/// Direct solvers multiply this value by their `precision` to get a tolerance
/// that is relative to the size of the matrix entries.
double maxAbsValue(Iterable<double> values) =>
    values.fold(0, (maxValue, value) => math.max(maxValue, value.abs()));

/// Returns whether [a] and [b] have the same length and the same values in
/// the same order.
bool sameValues(List<double> a, List<double> b) {
  if (a.length != b.length) {
    return false;
  }

  for (var i = 0; i < a.length; ++i) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}

/// Validates the inputs shared by the iterative solvers.
///
/// Throws a [SystemSolverException] if:
///
///  - the length of [x0] is not the size of the (square) [matrix];
///  - [x0] contains NaN or infinite values;
///  - [maxSteps] is smaller than 1;
///  - an element on the main diagonal of [matrix] is zero, because every
///    iteration divides by the diagonal elements.
void validateIterativeSolver({
  required RealMatrix matrix,
  required List<double> x0,
  required int maxSteps,
}) {
  if (x0.length != matrix.rowCount) {
    throw const SystemSolverException(
      'The length of the initial guess x0 must match the size of the matrix.',
    );
  }

  if (!x0.every((value) => value.isFinite)) {
    throw const SystemSolverException(
      'The initial guess x0 must contain only finite values.',
    );
  }

  if (maxSteps < 1) {
    throw const SystemSolverException('The maxSteps value must be at least 1.');
  }

  for (var i = 0; i < matrix.rowCount; ++i) {
    if (matrix(i, i) == 0) {
      throw const SystemSolverException(
        'The matrix has a zero on its main diagonal, so the iterative method '
        'cannot be used.',
      );
    }
  }
}

/// Returns whether an iterative method has converged, given the largest
/// change of a component in the last step ([maxChange]) and the largest
/// absolute value of a component after the step ([maxValue]).
///
/// The method has converged when `maxChange <= precision * max(1, maxValue)`.
/// The tolerance is absolute when the solution is small and relative when it
/// is large, so solutions with large components (where rounding alone makes
/// components change by more than [precision]) can still converge.
///
/// Throws a [SystemSolverException] if [maxChange] or [maxValue] is not
/// finite, which means that the method is diverging. [methodName] is used in
/// the error message.
bool hasConverged({
  required double maxChange,
  required double maxValue,
  required double precision,
  required String methodName,
}) {
  if (!maxChange.isFinite || !maxValue.isFinite) {
    throw SystemSolverException(
      'The $methodName diverged: the solution is no longer finite.',
    );
  }

  return maxChange <= precision * math.max(1, maxValue);
}

/// Returns the exception thrown when an iterative method hasn't converged
/// within [maxSteps] iterations. [methodName] is used in the error message.
SystemSolverException notConvergedException(String methodName, int maxSteps) =>
    SystemSolverException(
      'The $methodName did not converge within $maxSteps steps.',
    );

/// Runs the Successive Over-Relaxation iteration with relaxation factor [w]
/// on the system `Ax = b`, where `A` is [matrix] and `b` is [knownValues],
/// starting from [x0]. With `w = 1`, this is the Gauss-Seidel iteration.
///
/// The components are updated in place, so each update uses the components
/// already computed in the same step.
///
/// Returns the solution as soon as [hasConverged] is `true`. Throws a
/// [SystemSolverException] if the method diverges or doesn't converge within
/// [maxSteps] iterations. [methodName] is used in the error messages.
List<double> sorIteration({
  required RealMatrix matrix,
  required List<double> knownValues,
  required List<double> x0,
  required double w,
  required double precision,
  required int maxSteps,
  required String methodName,
}) {
  final n = knownValues.length;
  final a = matrix.flattenData;
  final x = List<double>.of(x0, growable: false);

  for (var step = 0; step < maxSteps; ++step) {
    var maxChange = 0.0;
    var maxValue = 0.0;

    for (var i = 0; i < n; ++i) {
      final row = n * i;
      var sigma = 0.0;
      for (var j = 0; j < n; ++j) {
        if (j != i) {
          sigma += a[row + j] * x[j];
        }
      }

      final updated =
          (1 - w) * x[i] + w * (knownValues[i] - sigma) / a[row + i];
      maxChange = math.max(maxChange, (updated - x[i]).abs());
      maxValue = math.max(maxValue, updated.abs());
      x[i] = updated;
    }

    if (hasConverged(
      maxChange: maxChange,
      maxValue: maxValue,
      precision: precision,
      methodName: methodName,
    )) {
      return x;
    }
  }

  throw notConvergedException(methodName, maxSteps);
}
