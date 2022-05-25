import 'package:equations/equations.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';

/// Wrapper class that holds the [NonLinear] type computed by [NonlinearState].
class NonlinearResult {
  /// The [NonLinear] object holding the nonlinear equation data.
  ///
  /// When `null`, it means that there has been an error while computing the
  /// roots.
  final NonLinear? nonlinear;

  /// Creates a [NonlinearResult] object.
  const NonlinearResult({
    this.nonlinear,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is NonlinearResult) {
      return runtimeType == other.runtimeType && nonlinear == other.nonlinear;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => nonlinear.hashCode;
}
