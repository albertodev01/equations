## 7.0.0

 - **BREAKING**: `Quartic.solutions` may return the roots in a different order
 - **BREAKING**: `Algebraic.factor` now includes the leading coefficient as a `Constant` factor when it is not 1, so the product of the factors always equals the original polynomial
 - **BREAKING**: `GenericAlgebraic.solutions` now throws an `AlgebraicException` when `initialGuess` is not empty and doesn't contain exactly one value per root, or when `minGuessDistance` is not positive. It no longer throws when the leading coefficient is very small (but not zero)
 - **BREAKING**: `SylvesterMatrix` is now a `final` class
 - **BREAKING**: `Algebraic.solveInequality` now joins intervals that touch (for example, `(x - 1)^2 * (x - 3) <= 0` returns `x <= 3` instead of `x <= 1`, `[1, 1]` and `[1, 3]`), and its `precision` parameter is now the relative tolerance used to decide whether a value is a root, instead of the maximum imaginary part of a real root
 - **BREAKING**: `PolynomialLongDivision.divide` (and the `/` operator of `Algebraic`) no longer throws when the degree of the denominator is higher than the degree of the numerator: it returns a zero quotient and the numerator as the remainder
 - **BREAKING**: The `guesses` list returned by `SimpsonRule.integrate` and `TrapezoidalRule.integrate` now has `intervals + 1` elements, the values of the function at every point `x_0, x_1, ..., x_n`. Previously, `TrapezoidalRule` left out the value at the upper bound, and `SimpsonRule` overwrote the value at `x_(n-1)` with the value at the upper bound
 - **BREAKING**: `MidpointRule.integrate` now throws a `NumericalIntegrationException` when `intervals` is not positive, instead of returning `NaN` or throwing a `RangeError`
 - **BREAKING**: `AdaptiveQuadrature.integrate` now throws a `NumericalIntegrationException` when the function is not finite on the interval or when the algorithm doesn't converge within `AdaptiveQuadrature.maxDepth` subdivisions, instead of overflowing the stack or never returning (for example, with `1/sqrt(x)` on `[0, 1]` or `sqrt(x)` on `[-2, -1]`)
 - **BREAKING**: `Riddler` has been renamed to `Ridders`, the correct name of the method. `Riddler` is still available as a deprecated alias
 - **BREAKING**: `Bisection`, `Brent`, `Chords`, `RegulaFalsi` and `Ridders` now return the endpoint as the only guess when `f(a)` or `f(b)` is zero, instead of throwing a `NonlinearException` (`RegulaFalsi` already did this)
 - **BREAKING**: `NonLinear.evaluateOn` and `NonLinear.evaluateDerivativeOn` now return `double` instead of `num`. `evaluateDerivativeOn(0)` now returns the derivative instead of `NaN`, so `Newton` no longer throws when a guess is `0`
 - **BREAKING**: `Factorial.compute` now throws a `RangeError` when `n` is negative or greater than `20` (the largest factorial that fits in a 64-bit `int`), instead of returning `1` or an overflowed value. `Factorial.computeBigInt` now throws a `RangeError` when `n` is negative, instead of returning `1`
 - `Factorial` is now exported by `package:equations/equations.dart`
 - **BREAKING**: `Complex.nthRoot` now returns the principal root (argument `phase() / n`, so `nthRoot(2)` equals `sqrt()`), instead of the root with the smallest non-negative argument. It throws a `ComplexException` when `nth` is `0` (it returned `1`) or when `nth` is negative and the number is zero (it returned `NaN`). As a consequence, `Cubic.solutions` may return the roots in a different order
 - **BREAKING**: `Complex.pow` returns `1` for a zero exponent (`0^0` was `NaN`), throws a `ComplexException` when a zero base is raised to a negative power (it returned `Infinity + NaNi`), and computes integer exponents up to 1024 with repeated multiplications, so for example `Complex.i().pow(2)` is exactly `-1`
 - **BREAKING**: `Complex.toString`, `toStringAsFixed` and `toStringWithParenthesis` print zero as `0` instead of `0i` (this also affects `ComplexMatrix.toString`). `toStringAsFixed` omits a part that is zero after rounding (`Complex(5, 0.04).toStringAsFixed(1)` is `5.0`, it was `5.0 + 0.0i`). Whole numbers above about 9.2e18 are no longer printed as `9223372036854775807`
 - `Complex.abs`, `Complex.reciprocal` and the `/` operator no longer overflow or underflow with very large or very small parts (`/` uses Smith's algorithm). `Complex.sqrt` uses a formula without cancellation, so `Complex(-4, 0).sqrt()` is exactly `2i`
 - `Complex.exp`, `sin`, `cos`, `tan` and `cot` no longer return `NaN` parts when an intermediate value overflows (for example, `Complex(1000, 0).exp()` is `Infinity` and `Complex(1, 400).tan()` is `i`), and `sin` and `cos` are accurate when the imaginary part is small
 - `Complex.compareTo` orders numbers with `NaN` parts after all the others, as `double.compareTo` does
 - Added `Complex.log` (principal natural logarithm), `Complex.sinh`, `Complex.cosh`, `Complex.tanh` and `Complex.powComplex`, which raises a complex number to a complex exponent
 - Updated Dart SDK constraints to `^3.14.0`
 - Various bug fixes in `RealMatrix`, `ComplexMatrix` and the decomposition algorithms
 - Documentation improvements
 - Dependencies versions update

## 6.0.0
 - **BREAKING**: Renamed `DurandKerner` class to `GenericPolynomial`
 - **BREAKING**: The `AlgebraicDivision` class is now a `typedef` of an equivalent record type
 - Updated Dart SDK constraints to `^3.10.4`
 - Added a new `Algebraic.factor` method that factors the polynomial into irreducible factors.
 - Added a new `Algebraic.solveInequality` method that solves polynomial inequalities.
 - Added a new `Matrix<T>.isZero` method.
 - Added a new `Factorial.computeBigInt` method to calculate factorials using `BigInt` rather than `int`
 - Improvements to numerical stability of various algorithms
 - Fixed numerical issues in polynomial and nonlinear solvers
 - Documentation improvements
 - Removed demo Dart and Flutter applications from the `example/` folder
 - Dependencies versions update

## 5.0.2
 - Added a new subclass of `NumericalIntegration` called `AdaptiveQuadrature`, which implements the "adaptive quadrature" algorithm
 - Updated Dart SDK constraints to `^3.1.0`
 - Updates to the Dart and Flutter example projects
 - Dependencies versions update

## 5.0.1
 - Updates to the Dart and Flutter example projects
 - Dependencies versions update

## 5.0.0
 - **BREAKING**: Removed the `IntegralResults` type and replaced it with an equivalent record
 - **BREAKING**: Removed the `NonlinearResults` type and replaced it with an equivalent record
 - **BREAKING**: Added the `base` modifier to `Algebraic`, `NumericalIntegration`, `Interpolation`, `NonLinear`, and `SystemSolver` types
 - Updated Dart SDK constraints to `^3.0.0`
 - Updated the `analysis_options.yaml` file with more rules
 - Added more rules from the `dart_code_metrics` package
 - Updated the Flutter and Dart demos in the `example/` folder
 - Dependencies versions update

## 4.1.0
 - Updated Dart SDK constraints to `">=2.18.0 <3.0.0"`
 - Improved docstring comments
 - Updated the `analysis_options.yaml` file with more rules
 - Added more rules from the `dart_code_metrics` package
 - Updated the Flutter and Dart demos in the `example/` folder
 - README updates
 - Dependencies versions update

## 4.0.0
 - **BREAKING**: The `Complex.fromPolar` constructor now requires **named** parameters
 - **BREAKING**: The `Interpolation` constructor now requires **named** parameters
 - **BREAKING**: The `SylvesterMatrix` type now accepts an `Algebraic` type rather than a `List<Complex>`. As such, the `SylvesterMatrix.fromReal` constructor has been removed because a real polynomial can be built using `Algebraic.fromReal` instead
 - **BREAKING**: The `SystemSolver` type now accepts a `RealMatrix` type rather than a `List<List<double>>`. As such, the `size` parameter has also been removed because the size can be retrieved from the `RealMatrix` object itself
 - **BREAKING**: New names for `SystemSolver` parameters: changed `equations` to `matrix` and `constants` to `knownValues`
 - Updated Dart SDK constraints to `">=2.17.0 <3.0.0"`
 - Added `csc` (cosecant) and `sec` (secant) trigonometric functions to the `ExpressionParser` type
 - Migrated Dart code to 2.17 with super parameters
 - Updated the `analysis_options.yaml` file with almost all rules
 - Added more rules from the `dart_code_metrics` package
 - Updated the Flutter demo in the `example/` folder. Now the project can be run on all platforms (mobile, web and desktop)
 - Dependencies versions update

## 3.2.0
 - Dependencies versions update
 - Updated the `analysis_options.yaml` file with some more rules
 - Updated the Flutter demo in the `example/` folder
 - Updated the Dart demo in the `example/` folder
 - Minor documentation improvements

## 3.1.3
 - Dependencies versions update
 - Updated the `analysis_options.yaml` file with some more rules

## 3.1.2
 - Dependencies versions update
 - Updated the README file with some fixes
 - Added a new root-finding algorithm (`Riddler`, which implements Riddler's method)
 - Updated the Flutter demo in the `example/` folder

## 3.1.1
 - Dependencies versions update
 - Added more test cases
 - Updated the Flutter demo in the `example/` folder

## 3.1.0
 - **BREAKING**: Now `NumericalIntegration` requires the function through the constructor (previously it was passed to the `integrate()` function)
 - Added the `characteristicPolynomial()` method on `Matrix<T>` to compute the characteristic polynomial of a matrix
 - Fixed an issue in the `eigenvalue()` method
 - Fixed an issue in the `rank()` method
 - Added the `eigenDecomposition()` method on `Matrix<T>` to implement the "Eigendecomposition" algorithm
 - Added the `Matrix.diagonal()` constructor on `Matrix<T>` to create diagonal matrices
 - Added more lints and stricter rules in `analysis_options.yaml`
 - Dependencies versions update

## 3.0.0
 - **BREAKING**: Replaced the `Laguerre` type with `DurandKerner` (the latter is a more reliable root-finding algorithm for polynomials)
 - **BREAKING**: Removed the `integrateOn` method on `Nonlinear`. Now numerical integration algorithms live on their own in the `src/integral` folder
 - **BREAKING**: Renamed `firstGuess` and `secondGuess` to `a` and `b` respectively in `Secant` (for consistency with other `Nonlinear` types)
 - Created the `Interpolation` type to work with point interpolation
 - Moved `NumericalIntegration` into a 'top-level' directory inside `src/`
 - Added the `LinearInterpolation`, `PolynomialInterpolation`, and `NewtonInterpolation` types
 - Added eigenvalues computation on `Matrix<T>` with the `eigenValues()` method
 - Added inverse matrix computation on `Matrix<T>` with the `inverse()` method
 - Added cofactor matrix computation on `Matrix<T>` with the `cofactor()` method
 - Added the `isSymmetric()` method to determine whether a matrix is symmetric or not
 - Added minor computation on `Matrix<T>` with the `minor(int row, int col)` method
 - Added SVD decomposition algorithm to matrix types
 - Added the `isDiagonal()` method on `Matrix<T>`
 - Added the `isIdentity()` method on `Matrix<T>`
 - Added the `trace()` method on `Matrix<T>`
 - Added the `rank()` method on `Matrix<T>`
 - Bug fixes on various matrix operations
 - Bug fixes in `Algebraic`
 - Dependencies versions update

## 2.1.3
 - Dependencies versions update
 - Minor enhancement in the `PolynomialLongDivision` class
 - Added trace computation on matrices
 - Added French localization to the Flutter example app

## 2.1.2
 - Dependencies versions update
 - Updated the example to Flutter 2.2.0 and improved coverage
 - Added `bool hasSolution()` on the `SystemSolver` type to determine whether a system can be solved or not

## 2.1.1
 - Added QR decomposition to the `RealMatrix` and `ComplexMatrix` types
 - Dependencies versions update

## 2.1.0
 - Changes in deep copy logic for lists (now the library uses `List.from()` on immutable objects)
 - Added the `PolynomialLongDivision` class to divide a polynomial by another
 - Now the `Algebraic` type supports `operator/` too, so you can divide polynomials to get quotient and remainder
 - Dependencies versions update

## 2.0.3
 - Dependencies versions update

## 2.0.2
 - New extension method on `String` called `isRealFunction` that determines whether a string represents a real function or not
 - New extension method on `String` called `isNumericalExpression` that determines whether a string represents a numerical expression or not
 - Minor changes to the `ExpressionParser` class
 - Wrote more tests for the `flutter_example` demo project
 - Dependencies versions update

## 2.0.1
 - New `toStringAsFixed()` method for the `Complex` type
 - Improved static analysis with a more elaborate `analysis_options.yaml` file
 - Dependencies versions update

## 2.0.0
 - Migration to stable null safety
 - Dependencies versions update

## 2.0.0-nullsafety.5
  - Updated some dependencies versions
  - Added support for numerical integration with the `NumericalIntegration` type
  - Minor code improvements

## 2.0.0-nullsafety.4
  - Updated some dependencies versions
  - Added a new root-finding algorithm (`RegulaFalsi`)
  - Improved the computation of the determinant (now it uses LU decomposition)
  - Minor documentation improvements

## 2.0.0-nullsafety.3
  - Added support for solving linear systems using Jacobi, Gauss-Seidel and SOR
  - Improved comparison logic for all the classes of the package
  - Added the new `toStringAugmented()` method for systems which prints the augmented matrix
  - Wrote more tests for coverage
  - Expanded the README.md file
  - New examples in the `example/` folder

## 2.0.0-nullsafety.2
  - Created the `RealMatrix` and `ComplexMatrix` types to work with matrices
  - Added support for solving linear systems using Gauss, LU decomposition and Cholesky decomposition
  - Added a new static method called `Algebraic.from()`, which automatically builds a new polynomial
    equation according to the number of coefficients
  - Minor documentation fixes

## 2.0.0-nullsafety.1
  - Added a new root-finding algorithm (`Brent`, which implements Brent's method)
  - Added `Laguerre` (which implements Laguerre's method for polynomial root-finding)
  - Minor improvements on various `Nonlinear` subtypes
  - Documentation fixes

## 2.0.0-nullsafety.0
  - Package migrated to null safety (Dart 2.12)
  - Added a new `ExpressionParser` class (which is also internally used by `NonLinear`)
  - Minor fixes on `Algebraic` and `NonLinear`

## 1.0.1
  - Fixed package health suggestions from pub.dev
  - Changed the description of the package

## 1.0.0
 - Initial release
 - Use `Algebraic` for algebraic (polynomial) equations and `Nonlinear` for nonlinear equations
 - Easily work with complex numbers by using `Complex`
