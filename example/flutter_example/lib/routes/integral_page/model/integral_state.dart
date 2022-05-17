import 'package:equations/equations.dart';
import 'package:equations_solver/routes/integral_page/model/integral_result.dart';
import 'package:flutter/widgets.dart';

/// Represents the analyzers of numerical integration algorithms available to compute
/// the solution of a definite integral.
enum IntegralType {
  /// The midpoint rule.
  midPoint,

  /// The Simpson rule.
  simpson,

  /// The trapezoidal rule.
  trapezoid,
}

/// TODO
class IntegralState extends ChangeNotifier {
  var state = const IntegralResult();

  /// Creates a [IntegralState] object.
  IntegralState();

  /// Tries to solve a polynomial equation with the given coefficients.
  void solveIntegral({
    required String upperBound,
    required String lowerBound,
    required String function,
    required int intervals,
    required IntegralType integralType,
  }) {
    try {
      final NumericalIntegration integration;

      const parser = ExpressionParser();
      final lower = parser.evaluate(lowerBound);
      final upper = parser.evaluate(upperBound);

      switch (integralType) {
        case IntegralType.midPoint:
          integration = MidpointRule(
            function: function,
            lowerBound: lower,
            upperBound: upper,
            intervals: intervals,
          );
          break;
        case IntegralType.simpson:
          integration = SimpsonRule(
            function: function,
            lowerBound: lower,
            upperBound: upper,
            intervals: intervals,
          );
          break;
        case IntegralType.trapezoid:
          integration = TrapezoidalRule(
            function: function,
            lowerBound: lower,
            upperBound: upper,
            intervals: intervals,
          );
          break;
      }

      // Integrating and returning the result
      final integrationResult = integration.integrate();

      state = IntegralResult(
        numericalIntegration: integration,
      );
    } on Exception {
      state = const IntegralResult();
    }

    notifyListeners();
  }

  /// Clears the state.
  void clear() {
    state = const IntegralResult();
    notifyListeners();
  }
}
