import 'package:equations/equations.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';

/// Wrapper class that holds the [Algebraic] type computed by [PolynomialState].
class PolynomialResult {
  /// The [Algebraic] object holding the polynomial data.
  ///
  /// When `null`, it means that there has been an error while computing the
  /// roots.
  final Algebraic? algebraic;

  /// Creates a [PolynomialResult] object.
  const PolynomialResult({
    this.algebraic,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is PolynomialResult) {
      return runtimeType == other.runtimeType && algebraic == other.algebraic;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => algebraic.hashCode;
}
