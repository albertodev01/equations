import 'package:equations/equations.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';

/// Wrapper class that holds the [SystemSolver] type computed by [SystemState].
class SystemResult {
  /// The [SystemSolver] object holding the system data.
  ///
  /// When `null`, it means that there has been an error while computing the
  /// solutions.
  final SystemSolver? systemSolver;

  /// Creates a [SystemResult] object.
  const SystemResult({
    this.systemSolver,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SystemResult) {
      return runtimeType == other.runtimeType &&
          systemSolver == other.systemSolver;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hashAll([systemSolver]);
}
