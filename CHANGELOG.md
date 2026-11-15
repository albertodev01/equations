## 7.0.0
 - **BREAKING**: Removed `Cubic.epsilon`. A `Cubic` object no longer throws when the leading coefficient is very small (but not zero), so `Cubic.new` and `Cubic.realEquation` now behave the same, and `Quartic.derivative()` and `Algebraic.from` no longer throw for valid polynomials whose leading coefficient is very small
 - **BREAKING**: Removed `Quartic.epsilon`, `Quartic.maxCoefficient` and `Quartic.minCoefficient`. A `Quartic` object no longer throws when a coefficient is larger than `1e10`
 - **BREAKING**: `Quartic.solutions` may return the roots in a different order
 - **BREAKING**: `Algebraic.factor` now includes the leading coefficient as a `Constant` factor when it is not 1, so the product of the factors always equals the original polynomial
 - **BREAKING**: Removed `GenericAlgebraic.stagnationThreshold`, which had no effect
 - **BREAKING**: `GenericAlgebraic.solutions` now throws an `AlgebraicException` when `initialGuess` is not empty and doesn't contain exactly one value per root, or when `minGuessDistance` is not positive. It no longer throws when the leading coefficient is very small (but not zero)
 - **BREAKING**: `GenericAlgebraic.precision` is now a relative tolerance
 - **BREAKING**: `SylvesterMatrix` is now a `final` class
 - **BREAKING**: `Algebraic.solveInequality` now joins intervals that touch (for example, `(x - 1)^2 * (x - 3) <= 0` returns `x <= 3` instead of `x <= 1`, `[1, 1]` and `[1, 3]`), and its `precision` parameter is now the relative tolerance used to decide whether a value is a root, instead of the maximum imaginary part of a real root
 - **BREAKING**: `PolynomialLongDivision.divide` (and the `/` operator of `Algebraic`) no longer throws when the degree of the denominator is higher than the degree of the numerator: it returns a zero quotient and the numerator as remainder
 - Updated Dart SDK constraints to `^3.14.0`
 - Fixed the `+` and `-` operators of `Algebraic`, which dropped zero coefficients in the middle of the result (for example, `x^2 + 1` could become `x + 1`)
 - The `+`, `-` and `*` operators of `Algebraic` now return the zero polynomial when the result is zero (for example, `p - p`), instead of throwing an `AlgebraicException`
 - Fixed `Algebraic.solveInequality` with non-strict inequalities (`≤` and `≥`), negative leading coefficients, and the zero polynomial
 - Fixed `Algebraic.solveInequality`, which ignored repeated real roots computed with a small imaginary part (for example, `(x - 2)^5 > 0` had no solutions), returned duplicate intervals for repeated roots, and could drop isolated solutions such as `x = 3` in `(x - 1)(x - 2)^2(x - 3)^2 <= 0`
 - Added the `AlgebraicInequalitySolver` class, which solves polynomial inequalities and is used by `Algebraic.solveInequality`
 - `Algebraic.evaluateOn`, `Algebraic.realEvaluateOn` and `Algebraic.evaluateIntegralOn` now use Horner's method, so they're more accurate and real polynomials no longer get a spurious imaginary part at negative values
 - Fixed `Quadratic.solutions`, which returned `NaN` or inaccurate roots when the roots cancelled out in the quadratic formula (for example, `x^2 + 2x` and `x^2 + ix`)
 - Fixed `Cubic.solutions`, which returned wrong roots when the equation had a double root, merged distinct small roots into one, and lost precision in Cardano's formula
 - Fixed `PolynomialLongDivision.divide` (and the `/` operator of `Algebraic`), which returned wrong results or threw when the denominator had degree 2 or higher (for example, `x^3 / (x^2 + 1)` returned a remainder of `-1` instead of `-x`), returned `1` for `0 / 0`, and threw a `TypeError` when dividing by the zero polynomial. Dividing by the zero polynomial now always throws a `PolynomialLongDivisionException`, and the division is faster for low-degree denominators
 - Fixed `GenericAlgebraic.solutions`, which returned wrong roots without error when the starting points were close together (for example, `x^5 - 0.001` and equal values in `initialGuess`), returned `NaN` for `x^n`, and returned different results on each call. The default starting points now use a valid bound for the roots
 - Fixed `Quartic.solutions`, which treated coefficients smaller than `1e-10` as zero (returning wrong roots, such as four zeros for `x^4 - 1e-12`), dropped small roots of biquadratic equations, and returned inaccurate roots (errors up to about `0.04`) when the equation had repeated roots
 - Fixed `SylvesterMatrix`, which treated coefficients smaller than `1e-10` as zero (for example, the discriminant of `x^5 + 1e-11x` was `0`) and threw a `MatrixException` when the leading coefficient was very small (but not zero). A `GenericAlgebraic` of degree 4 or lower now uses the closed-form discriminant
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
 - Fixed numerical issues on polynonial and nonlinear solvers
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
 - **BREAKING**: Removed the `IntegralResults` type and replaced with an equivalent record
 - **BREAKING**: Removed the `NonlinearResults` type and replaced with an equivalent record
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
 - Added a new root-finding algorithm (`Riddler` which implements the Riddler's method)
 - Updated the Flutter demo in the `example/` folder

## 3.1.1
 - Dependencies versions update
 - Added more test cases
 - Updated the Flutter demo in the `example/` folder

## 3.1.0
 - **BREAKING**: Now `NumericalIntegration` requires the function via constructor (previously it was passed to the `integrate()` function)
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
 - Created the `Interpolation` type to work with points interpolation
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
 - Updated example to Flutter 2.2.0 and improved coverage
 - Added `bool hasSolution()` on the `SystemSolver` type to determine whether a system can be solved or not

## 2.1.1
 - Added QR decomposition to the `RealMatrix` and `ComplexMatrix` type
 - Dependencies versions update

## 2.1.0
 - Changes in deep copy logic for lists (now the library uses `List.from()` on immutable objects)
 - Added the `PolynomialLongDivision` class to divide a polynomial by another
 - Now the `Algebraic` type supports `operator/` too so you can divide polynomials to get quotient and remainder
 - Dependencies versions update

## 2.0.3
 - Dependencies versions update

## 2.0.2
 - New extension method on `String` called `isRealFunction` that determines whether a string represents a real function or not
 - New extension method on `String` called `isNumericalExpression` that determines whether a string represents a numerical expression or not
 - Minor changes to the `ExpressionParser` class
 - Written more tests for the `flutter_example` demo project
 - Dependencies versions update

## 2.0.1
 - New `toStringAsFixed()` method for the `Complex` type
 - Improved static analysis with a more elaborated `analysis_options.yaml` file
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
  - Added a new root finding algorithm (`RegulaFalsi`)
  - Improved the computation of the determinant (now it uses LU decomposition which is way better than the old O(n!) implementation)
  - Minor documentation improvements

## 2.0.0-nullsafety.3
  - Added support for linear systems solving using Jacobi, Gauss-Seidel and SOR
  - Improved comparison logic for all the classes of the package
  - Added the new `toStringAugmented()` method for systems which prints the augmented matrix
  - Written more tests for coverage
  - Expanded the README.md file
  - New examples in the `example/` folder

## 2.0.0-nullsafety.2
  - Created the `RealMatrix` and `ComplexMatrix` types to work with matrices
  - Added support for linear systems solving using Gauss, LU decomposition and Cholesky decomposition
  - Added a new static method called `Algebraic.from()` which automatically builds a new polynomial
    equation according to the number of coefficients
  - Minor documentation fixes

## 2.0.0-nullsafety.1
  - Added a new root-finding algorithm (`Brent` which implements Brent's method)
  - Added `Laguerre` (which implements Laguerre's method for polynomials root finding)
  - Minor improvements on various `Nonlinear` subtypes
  - Documentation fixes

## 2.0.0-nullsafety.0
  - Package migrated to null safety (Dart 2.12)
  - Added a new `ExpressionParser` class (which is also internally used by `NonLinear`)
  - Minor fixes on `Algebraic` and `NonLinear`

## 1.0.1
  - Health suggestions fixes
  - Changed the description of the package

## 1.0.0
 - Initial release
 - Use `Algebraic` for algebraic (polynomial) equations and `Nonlinear` for nonlinear equations
 - Easily work with complex numbers by using `Complex`
