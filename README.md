<p align="center">
<img src="https://raw.githubusercontent.com/albertodev01/equations/master/assets/equations_logo.svg" height="92" alt="dart_equations logo" />
</p>
<p align="center">An equation-solving library written purely in Dart.</p>
<p align="center">
    <a href="https://codecov.io/gh/albertodev01/equations"><img src="https://codecov.io/gh/albertodev01/equations/branch/master/graph/badge.svg?token=OQFZFHPD3S"/></a>
    <a href="https://github.com/albertodev01/equations/actions"><img src="https://github.com/albertodev01/equations/workflows/equations_ci/badge.svg" alt="CI status" /></a>
    <a href="https://github.com/albertodev01/equations/stargazers"><img src="https://img.shields.io/github/stars/albertodev01/equations.svg?style=flat&logo=github&colorB=blue&label=stars" alt="Stars count on GitHub" /></a>
  <a href="https://pub.dev/packages/equations"><img src="https://img.shields.io/pub/v/equations.svg?style=flat&logo=github&colorB=blue" alt="Stars count on GitHub" /></a>
</p>

---

The `equations` package is used to solve numerical analysis problems with ease. It's purely written in Dart, meaning it has no platform-specific dependencies and doesn't require Flutter to work. You can use `equations`, for example, in a Dart CLI project or a Flutter cross-platform application. Here's a summary of what you can do with this package:

  - solve polynomial equations with `Algebraic` types;
  - solve nonlinear equations with `Nonlinear` types;
  - solve linear systems of equations with `SystemSolver` types;
  - evaluate integrals with `NumericalIntegration` types;
  - interpolate data points with `Interpolation ` types.

In addition, you can also find utilities to work with:

  - Real and complex matrices, using the `Matrix<T>` types;
  - Complex number, using the `Complex` type;
  - Fractions, using the `Fraction` and `MixedFraction` types.

This package has a type-safe API and requires Dart 3.0 (or higher versions). There is a demo project created with Flutter that shows an example of how this library could be used to develop a numerical analysis application  :rocket:

<p align="center"><img src="https://raw.githubusercontent.com/albertodev01/equations/master/assets/circle_logo.svg" alt="Equation Solver logo" width="55" height="55" /></p>
<p align="center"><a href="https://albertodev01.github.io/equations/">Equation Solver - Flutter web demo</a></p>

The source code of the Flutter application can be found at `example/flutter_example/`. Visit the official [pub.dev documentation](https://pub.dev/documentation/equations/latest/) for details about methods signatures and inline documentation.

---

# Algebraic (Polynomial equations)

Use one of the following classes to find the roots of a polynomial equation (also known as "algebraic equation"). You can use both complex numbers and fractions as coefficients.

| Solver name |                                  Equation                                 |    Params field   |
|:-----------:|:-------------------------------------------------------------------------:|:-----------------:|
| `Constant`  | <em>f(x) = a</em>                                                         | a ∈ C             |
| `Linear`    | <em>f(x) = ax + b</em>                                                    | a, b ∈ C          |
| `Quadratic` | <em>f(x) = ax<sup>2</sup> + bx + c</em>                                   | a, b, c ∈ C       |
| `Cubic`     | <em>f(x) = ax<sup>3</sup> + bx<sup>2</sup> + cx + d</em>                  | a, b, c, d ∈ C    |
| `Quartic`   | <em>f(x) = ax<sup>4</sup> + bx<sup>3</sup> + cx<sup>2</sup> + dx + e</em> | a, b, c, d, e ∈ C |
| `DurandKerner` | Any polynomial P(x<sub>i</sub>) where x<sub>i</sub> are coefficients      | x<sub>i</sub> ∈ C |

There's a formula for polynomials up to the fourth degree, as explained by the [Galois theory](https://en.wikipedia.org/wiki/Galois_theory). Roots of polynomials whose degree is 5 or higher must be found using DurandKerner's method (or any other root-finding algorithm). For this reason, we suggest the following approach:

  - use `Linear` to find the roots of a polynomial whose degree is 1;
  - use `Quadratic` to find the roots of a polynomial whose degree is 2;
  - use `Cubic` to find the roots of a polynomial whose degree is 3;
  - use `Quartic` to find the roots of a polynomial whose degree is 4;
  - use `DurandKerner` to find the roots of a polynomial whose degree is 5 or higher.

Since `DurandKerner` works with any polynomial, you could also use it (for example) to solve a cubic equation. However, `DurandKerner` internally uses loops, derivatives, and other mechanics to approximate the actual roots. When the degree is 4 or lower, prefer working with `Quartic`, `Cubic`, `Quadratic` or `Linear` because they use direct formulas to find the roots (and thus they're more precise). Here's an example of how to find the roots of a cubic:

```dart
// f(x) = (2-3i)x^3 + 6/5ix^2 - (-5+i)x - (9+6i)
final equation = Cubic(
  a: Complex(2, -3),
  b: Complex.fromImaginaryFraction(Fraction(6, 5)),
  c: Complex(5, -1),
  d: Complex(-9, -6)
);

final degree = equation.degree; // 3
final isReal = equation.isRealEquation; // false
final discr = equation.discriminant(); // -31299.688 + 27460.192i

// f(x) = (2 - 3i)x^3 + 1.2ix^2 + (5 - 1i)x + (-9 - 6i)
print('$equation');

// f(x) = (2 - 3i)x^3 + 6/5ix^2 + (5 - 1i)x + (-9 - 6i)
print(equation.toStringWithFractions());

/*
 * Prints the roots:
 *
 *  x1 = 0.348906207844 - 1.734303423032i
 *  x2 = -1.083892638909 + 0.961044482775
 *  x3 = 1.011909507988 + 0.588643555642
 * */
for (final root in equation.solutions()) {
  print(root);
}
```

Alternatively, you could have used `DurandKerner` to solve the same equation:

```dart
// f(x) = (2-3i)x^3 + 6/5ix^2 - (-5+i)x - (9+6i)
final equation = DurandKerner(
  coefficients: [
    Complex(2, -3),
    Complex.fromImaginaryFraction(Fraction(6, 5)),
    Complex(5, -1),
    Complex(-9, -6),
  ]
);

/*
 * Prints the roots of the equation:
 *
 *  x1 = 1.0119095 + 0.5886435
 *  x2 = 0.3489062 - 1.7343034i
 *  x3 = -1.0838926 + 0.9610444
 * */
for (final root in equation.solutions()) {
  print(root);
}
```

As we've already pointed out, both ways are equivalent. However, `DurandKerner` is computationally slower than `Cubic` and doesn't always guarantee to converge to the correct roots. Use `DurandKerner` only when the degree of your polynomial is greater or equal to 5.

```dart
final quadratic = Algebraic.from(const [
  Complex(2, -3),
  Complex.i(),
  Complex(1, 6)
]);

final quartic = Algebraic.fromReal(const [
  1, -2, 3, -4, 5
]);
```

The factory constructor `Algebraic.from()` automatically returns the best type of `Algebraic` according to the number of parameters you've passed.

# Nonlinear equations

Use one of the following classes, representing a root-finding algorithm, to find a root of an equation. Only real numbers are allowed. This package supports the following root-finding methods:

| Solver name  | Params field      |
|:------------:|:-----------------:|
| `Bisection`  | a, b ∈ R          |
| `Chords`     | a, b ∈ R          |
| `Netwon`     | x<sub>0</sub> ∈ R |
| `Secant`     | a, b ∈ R          |
| `Steffensen` | x<sub>0</sub> ∈ R |
| `Brent`      | a, b ∈ R          |
| `RegulaFalsi`| a, b ∈ R          |

Expressions are parsed using [petitparser](https://pub.dev/packages/petitparser/): a fast, stable and well-tested grammar parser. Here's a simple example of how you can find the roots of an equation using Newton's method:

```dart
final newton = Newton("2*x+cos(x)", -1, maxSteps: 5);

final steps = newton.maxSteps; // 5
final tol = newton.tolerance; // 1.0e-10
final fx = newton.function; // 2*x+cos(x)
final guess = newton.x0; // -1

final solutions = newton.solve();

final convergence = solutions.convergence.round(); // 2
final solutions = solutions.efficiency.round(); // 1

/*
 * The getter `solutions.guesses` returns the list of values computed by the algorithm
 *
 * -0.4862880170389824
 * -0.45041860473199363
 * -0.45018362150211116
 * -0.4501836112948736
 * -0.45018361129487355
 */
final List<double> guesses = solutions.guesses;
```

Certain algorithms don't always guarantee to converge to the correct root so carefully read the documentation before choosing the method.

# Systems of equations

Use one of the following classes to solve systems of linear equations. Only real coefficients are allowed (so `double` is ok, but `Complex` isn't) and you must define `N` equations in `N` variables (so **square** matrices only are allowed). This package supports the following algorithms:

| Solver name           | Iterative method   |
|:---------------------:|:------------------:|
| `CholeskySolver`      | :x:                |
| `GaussianElimination` | :x:                |
| `GaussSeidelSolver`   | :heavy_check_mark: |
| `JacobiSolver`        | :heavy_check_mark: |
| `LUSolver`            | :x:                |
| `SORSolver`           | :heavy_check_mark: |

These solvers are used to find the `x` in the `Ax = b` equation. Methods require, at least, the system matrix `A` and the known values vector `b`. Iterative methods may require additional parameters such as an initial guess or a particular configuration value. For example:

```dart
// Solve a system using LU decomposition
final luSolver = LUSolver(
  equations: const [
    [7, -2, 1],
    [14, -7, -3],
    [-7, 11, 18]
  ],
  constants: const [12, 17, 5]
);

final solutions = luSolver.solve(); // [-1, 4, 3]
final determinant = luSolver.determinant(); // -84.0
```

If you just want to work with matrices (for operations, decompositions, eigenvalues, etc...) you can consider using either `RealMatrix` (to work with `double`) or `ComplexMatrix` (to work with `Complex`). Both are subclasses of `Matrix<T>` so they have the same public API:

```dart
final matrixA = RealMatrix.fromData(
  columns: 2,
  rows: 2,
  data: const [
    [2, 6],
    [-5, 0]
  ]
);

final matrixB = RealMatrix.fromData(
  columns: 2,
  rows: 2,
  data: const [
    [-4, 1],
    [7, -3],
  ]
);

final sum = matrixA + matrixB;
final sub = matrixA - matrixB;
final mul = matrixA * matrixB;
final div = matrixA / matrixB;

final lu = matrixA.luDecomposition();
final cholesky = matrixA.choleskyDecomposition();
final cholesky = matrixA.choleskyDecomposition();
final qr = matrixA.qrDecomposition();
final svd = matrixA.singleValueDecomposition();

final det = matrixA.determinant();
final rank = matrixA.rank();

final eigenvalues = matrixA.eigenvalues();
final characPolynomial = matrixA.characteristicPolynomial();
```

You can use `toString()` to print the matrix contents. The `toStringAugmented()` method prints the augmented matrix (the matrix + one extra column with the known values vector). For example:

```dart
final lu = LUSolver(
  equations: const [
    [7, -2, 1],
    [14, -7, -3],
    [-7, 11, 18]
  ],
  constants: const [12, 17, 5]
);

/*
 * Output with 'toString':
 *
 * [7.0, -2.0, 1.0]
 * [14.0, -7.0, -3.0]
 * [-7.0, 11.0, 18.0]
*/
print("$lu");

/*
 * Output with 'toStringAugmented':
 *
 * [7.0, -2.0, 1.0 | 12.0]
 * [14.0, -7.0, -3.0 | 17.0]
 * [-7.0, 11.0, 18.0 | 5.0]
*/
print("${lu.toStringAugmented()}");
```

The `ComplexMatrix` has the same API and the same usage as `RealMatrix` with the only difference that it works with complex numbers rather then real numbers.

# Numerical integration

The "**numerical integration**" term refers to a group of algorithms for calculating the numerical value of a definite integral (on a given interval). The function must be continuous within the integration bounds. This package currently supports the following algorithms:

 - `MidpointRule`
 - `SimpsonRule`
 - `TrapezoidalRule`

Other than the integration bounds (called `lowerBound` and `lowerBound`), the classes also have an optional parameter called `intervals`. It already has a good default value but of course you can change it!

```dart
const simpson = SimpsonRule(
  function: 'sin(x)*e^x',
  lowerBound: 2,
  upperBound: 4,
);

// Calculating the value of...
//
//   ∫ sin(x) * e^x dx
//
// ... between 2 and 4.
final results = simpson.integrate();

// Prints '-7.713'
print('${results.result.toStringAsFixed(3)}');

// Prints '32'
print('${results.guesses.length}');
```

The `integrate()` function returns an `IntegralResults` which simply is a wrapper for 2 values:

  1. `result`: the value of the definite integral evaluated within `lowerBound` and `lowerBound`,
  2. `guesses`: the various intermediate values that brought to the final result.

# Interpolation

This package can also perform linear, polynomial or spline interpolations using the `Interpolation` types. You just need to give a few points in the constructor and then use `compute(double x)` to interpolate the value. The package currently supports the following algorithms:

 - `LinearInterpolation`
 - `PolynomialInterpolation`
 - `NewtonInterpolation`
 - `SplineInterpolation`

You'll always find the `compute(double x)` method in any `Interpolation` type, but some classes may have additional methods that others haven't. For example:

```dart
const newton = NewtonInterpolation(
  nodes: [
    InterpolationNode(x: 45, y: 0.7071),
    InterpolationNode(x: 50, y: 0.7660),
    InterpolationNode(x: 55, y: 0.8192),
    InterpolationNode(x: 60, y: 0.8660),
  ],
);

// Prints 0.788
final y = newton.compute(52);
print(y.toStringAsFixed(3));

// Prints the following:
//
// [0.7071, 0.05890000000000006, -0.005700000000000038, -0.0007000000000000339]
// [0.766, 0.053200000000000025, -0.006400000000000072, 0.0]
// [0.8192, 0.04679999999999995, 0.0, 0.0]
// [0.866, 0.0, 0.0, 0.0]
print('\n${newton.forwardDifferenceTable()}');
```

Since the Newton interpolation algorithm internally builds the "divided differences table", the API exposes two methods (`forwardDifferenceTable()` and `backwardDifferenceTable()`) to print those tables. Of course, you won't find `forwardDifferenceTable()` in other interpolation types because they just don't use it. By default, `NewtonInterpolation` uses the forward difference method but if you want the backward one, just pass `forwardDifference: false` in the constructor.

```dart
const polynomial = PolynomialInterpolation(
  nodes: [
    InterpolationNode(x: 0, y: -1),
    InterpolationNode(x: 1, y: 1),
    InterpolationNode(x: 4, y: 1),
  ],
);

// Prints -4.54
final y = polynomial.compute(-1.15);
print(y.toStringAsFixed(2));

// Prints -0.5x^2 + 2.5x + -1
print('\n${polynomial.buildPolynomial()}');
```

This is another example with a different interpolation strategy. The `buildPolynomial()` method returns the interpolation polynomial (as an `Algebraic` type) internally used to interpolate `x`.

# Expressions parsing

You can use the `ExpressionParser` type to either parse numerical expressions or evaluate mathematical functions with the `x` variable:

```dart
const parser = ExpressionParser();

print(parser.evaluate('5*3-4')); // 11
print(parser.evaluate('sqrt(49)+10')); // 17
print(parser.evaluate('pi')); // 3.1415926535

print(parser.evaluateOn('6*x + 4', 3)); // 22
print(parser.evaluateOn('sqrt(x) - 3', 81)); // 6
```

This type is internally used by the library to evaluate nonlinear functions.