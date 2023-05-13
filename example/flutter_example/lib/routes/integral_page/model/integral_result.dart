import 'package:equations/equations.dart';
import 'package:equations_solver/routes/integral_page.dart';

/// Wrapper class that holds the [NumericalIntegration] type computed by
/// [IntegralPage].
class IntegralResult {
  /// The [NumericalIntegration] object.
  ///
  /// When `null`, it means that there an error occurred while evaluating the
  /// integral.
  final NumericalIntegration? numericalIntegration;

  /// Creates an [IntegralResult] object.
  const IntegralResult({
    this.numericalIntegration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is IntegralResult) {
      return runtimeType == other.runtimeType &&
          numericalIntegration == other.numericalIntegration;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => numericalIntegration.hashCode;
}
