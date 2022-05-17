import 'package:equations/equations.dart';
import 'package:equations_solver/routes/integral_page.dart';

/// Wrapper class that holds the [NumericalIntegration] type computed by
/// [IntegralPage].
class IntegralResult {
  /// The [NumericalIntegration] object holding the polynomial data.
  ///
  /// When `null`, it means that there has been an error while computing the
  /// roots.
  final NumericalIntegration? numericalIntegration;

  /// Creates a [IntegralResult] object.
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
  int get hashCode => Object.hashAll([numericalIntegration]);
}
