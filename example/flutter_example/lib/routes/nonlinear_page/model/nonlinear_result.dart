import 'package:equations/equations.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';

/// Wrapper class that holds the [NonLinear] type computed by [NonlinearState].
class NonlineaerResult {
  /// The [NonLinear] object holding the nonlinear equation data.
  ///
  /// When `null`, it means that there has been an error while computing the
  /// roots.
  final NonLinear? nonlinear;

  /// Creates a [NonlineaerResult] object.
  const NonlineaerResult({
    this.nonlinear,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is NonlineaerResult) {
      return runtimeType == other.runtimeType && nonlinear == other.nonlinear;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hashAll([nonlinear]);
}
