import 'package:equations/equations.dart';
import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/integral_page/model/integral_result.dart';
import 'package:flutter/widgets.dart';

/// The type of numerical integration algorithms.
enum IntegralType {
  /// The midpoint rule.
  midPoint,

  /// The Simpson rule.
  simpson,

  /// The trapezoidal rule.
  trapezoid,
}

/// Holds the state of the [IntegralPage] page.
class IntegralState extends ChangeNotifier {
  var _state = const IntegralResult();

  /// The current state.
  IntegralResult get state => _state;

  /// Tries to integrate the given function within the intervals.
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
      _state = IntegralResult(
        numericalIntegration: integration,
      );
    } on Exception {
      _state = const IntegralResult();
    }

    notifyListeners();
  }

  /// Clears the state.
  void clear() {
    _state = const IntegralResult();
    notifyListeners();
  }
}
