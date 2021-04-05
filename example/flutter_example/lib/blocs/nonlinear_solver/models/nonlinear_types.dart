/// Represents the types of nonlinear fucntions that a bloc has to to handle
enum NonlinearType {
  /// Algorithms that require a single starting point
  singlePoint,

  /// Algorithms that bracket the root
  bracketing,
}

/// Root finding algorithm that require a single point to start the iterations
enum SinglePointMethods {
  /// Newton's method
  newton,

  /// Steffensen's method
  steffensen,
}

/// Root finding algorithm that need to bracket the root to start the iterations
enum BracketingMethods {
  /// Bisection method
  bisection,

  /// Secant method
  secant,

  /// Brent's method
  brent,
}
