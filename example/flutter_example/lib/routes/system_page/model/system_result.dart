import 'package:equations/equations.dart';

/// TODO
class SystemResult {
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
