## [3.1.3]
 - Dependencies versions update
 - Updated the `analysis_options.yaml` file with some more rules

## [3.1.2]
 - Dependencies versions update
 - Updated the README file with some fixes
 - Added a new root-finding algorithm (`Riddler` which implements the Riddler's method)
 - Updated the Flutter demo in the `example/` folder

## [3.1.1]
 - Dependencies versions update
 - Added more tests cases
 - Updated the Flutter demo in the `example/` folder

## [3.1.0]

 - **BREAKING**: Now `NumericalIntegration` requires the function via constructor (earlier it was passed to the `integrate()` function)
 - Added the `characteristicPolynomial()` method on `Matrix<T>` to compute the characteristic polynomial of a matrix
 - Fixed an issue in the `eigenvalue()` method
 - Fixed an issue in the `rank()` method
 - Added the `eigenDecomposition()` method on `Matrix<T>` to implement the "Eigendecomposition" algorithm
 - Added the `Matrix.diagonal()` constructor on `Matrix<T>` to create diagonal matrices
 - Added more lints and stricter rules in `analysis_options.yaml`
 - Dependencies versions update

## [3.0.0]

 - **BREAKING**: Replaced the `Laguerre` type with `DurandKerner` (the latter is a more reliable root-finding algorithm for polynomials)
 - **BREAKING**: Removed the `integrateOn` method on `Nonlinear`. Now numerical integration algorithms live on their own in the `src/integral` folder
 - **BREAKING**: renamed `firstGuess` and `secondGuess` to `a` and `b` respectively in `Secant` (for consistency with other `Nonlinear` types)
 - Created the `Interpolation` type to work with points interpolation
 - Moved `NumericalIntegration` into a 'top-level' directoy inside `src/`
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

## [2.1.3]

 - Dependencies versions update
 - Minor enhancement in the `PolynomialLongDivision` class
 - Added trace computation on matrices
 - Added french localization to the Flutter example app
 
## [2.1.2]

 - Dependencies versions update
 - Updated example to Flutter 2.2.0 and improved coverage
 - Added `bool hasSolution()` on the `SystemSolver` type to determine whether a system can be solved or not

## [2.1.1]

 - Added QR decomposition to the `RealMatrix` and `ComplexMatrix` type
 - Dependencies versions update

## [2.1.0]

 - Changes on deep copy logic for lists (now the library uses `List.from()` on immutable objects)
 - Added the `PolynomialLongDivision` class to divide a polynomial by another
 - Now the `Algebraic` type supports `opeartor/` too so you can divide polynomials to get quotient and remainder
 - Dependencies versions update

## [2.0.3]

 - Dependencies versions update

## [2.0.2]

 - New extension method on `String` called `isRealFunction` that determines whether a string represents a real function or not
 - New extension method on `String` called `isNumericalExpression` that determines whether a string represents numerical expression or not
 - Minor changes to the `ExpressionParser` class
 - Written more tests for the `flutter_example` demo project
 - Dependencies versions update

## [2.0.1]

 - New `toStringAsFixed()` method for the `Complex` type
 - Improved static analysis with a more elaborated `analysis_options.yaml` file
 - Dependencies versions update

## [2.0.0]

 - Migration to stable null safety
 - Dependencies versions update

## 2.0.0-nullsafety.5

  - Updated some dependencies versions
  - Added support for numerical integration with the `NumericalIntegration` type.
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

  - Created the `RealMatrix` and `ComplexMatrix` types to work with matrix
  - Added support for linear systems solving using Gauss, LU decomposition and Cholesky decomposition
  - Added a new static method called `Algebraic.from()` which automatically builds a new polynomial
    equation according with the number of coefficients.
  - Minor documentation fixes

## 2.0.0-nullsafety.1

  - Added a new root-finding algorithm (`Brent` which implements the Brent's method)
  - Added `Laguerre` (which implements Laguerre's method for polynomials root finding)
  - Minor on various `Nonlinear` subtypes
  - Documentation fixes

## 2.0.0-nullsafety.0

  - Package migrated to null safety (Dart 2.12).
  - Added a new `ExpressionParser` class (which is also internally used by `NonLinear`)
  - Minor fixes on `Algebraic` and `NonLinear`

## 1.0.1

  - Health suggestions fixes
  - Changed the description of the package

## 1.0.0

 - Initial release
 - Use `Algebraic` for algebraic (polynomial) equations and `Nonlinear` for nonlinear equations
 - Easily work with complex number by using `Complex`