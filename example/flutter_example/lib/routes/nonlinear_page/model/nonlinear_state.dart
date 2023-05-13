import 'package:equations/equations.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_result.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:flutter/widgets.dart';

/// The types of nonlinear equations that can be solved.
enum NonlinearType {
  /// Algorithms that require a single starting point.
  singlePoint,

  /// Algorithms that bracket the root.
  bracketing,
}

/// Root finding algorithm that require a single point to start the iterations.
enum SinglePointMethods {
  /// Newton's method.
  newton,

  /// Steffensen's method.
  steffensen,
}

/// Root finding algorithm that need to bracket the root to start the
/// iterations.
enum BracketingMethods {
  /// Bisection method.
  bisection,

  /// Secant method.
  secant,

  /// Brent's method.
  brent,
}

/// Holds the state of the [NonlinearPage] page.
class NonlinearState extends ChangeNotifier {
  var _state = const NonlinearResult();

  /// The type of nonlinear equations to solve.
  final NonlinearType nonlinearType;

  /// Creates a [NonlinearState] object.
  NonlinearState(this.nonlinearType);

  /// The current state.
  NonlinearResult get state => _state;

  /// Tries to return a [SinglePointMethods] value from a
  /// [NonlinearDropdownItems] value.
  static SinglePointMethods singlePointResolve(NonlinearDropdownItems item) {
    if (item == NonlinearDropdownItems.newton) {
      return SinglePointMethods.newton;
    }

    return SinglePointMethods.steffensen;
  }

  /// Tries to return a [BracketingMethods] value from a
  /// [NonlinearDropdownItems] value.
  static BracketingMethods bracketingResolve(NonlinearDropdownItems item) {
    if (item == NonlinearDropdownItems.secant) {
      return BracketingMethods.secant;
    }

    if (item == NonlinearDropdownItems.brent) {
      return BracketingMethods.brent;
    }

    return BracketingMethods.bisection;
  }

  /// Solves an equation using a bracketing algorithm.
  void solveWithBracketing({
    required String upperBound,
    required String lowerBound,
    required String function,
    required double precision,
    required BracketingMethods method,
  }) {
    try {
      const parser = ExpressionParser();
      final lower = parser.evaluate(lowerBound);
      final upper = parser.evaluate(upperBound);

      final solver = switch (method) {
        BracketingMethods.bisection => Bisection(
            function: function,
            a: lower,
            b: upper,
            maxSteps: 20,
            tolerance: precision,
          ),
        BracketingMethods.secant => Secant(
            function: function,
            a: lower,
            b: upper,
            maxSteps: 20,
            tolerance: precision,
          ),
        BracketingMethods.brent => Brent(
            function: function,
            a: lower,
            b: upper,
            maxSteps: 20,
            tolerance: precision,
          )
      };

      _state = NonlinearResult(
        nonlinear: solver,
      );
    } on Exception {
      _state = const NonlinearResult();
    }

    notifyListeners();
  }

  /// Solves an equation using a single point algorithm.
  void solveWithSinglePoint({
    required String initialGuess,
    required String function,
    required double precision,
    required SinglePointMethods method,
  }) {
    try {
      const parser = ExpressionParser();
      final x0 = parser.evaluate(initialGuess);

      final solver = switch (method) {
        SinglePointMethods.newton => Newton(
            function: function,
            x0: x0,
            maxSteps: 20,
            tolerance: precision,
          ),
        SinglePointMethods.steffensen => Steffensen(
            function: function,
            x0: x0,
            maxSteps: 20,
            tolerance: precision,
          )
      };

      _state = NonlinearResult(
        nonlinear: solver,
      );
    } on Exception {
      _state = const NonlinearResult();
    }

    notifyListeners();
  }

  /// Clears the state.
  void clear() {
    _state = const NonlinearResult();
    notifyListeners();
  }
}
