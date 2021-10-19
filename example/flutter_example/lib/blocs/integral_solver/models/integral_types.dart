/// Represents the types of numerical integration algorithms available to compute
/// the solution of a definite integral.
enum IntegralType {
  /// The midpoint rule.
  midPoint,

  /// The Simpson rule.
  simpson,

  /// The trapezoidal rule.
  trapezoid,
}
