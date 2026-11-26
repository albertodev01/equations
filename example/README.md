# Examples

Here is a quick overview of the main features of the `equations` package. For more details and examples, see the articles on the repository's Wiki:

 - [Algebraic equations](https://github.com/albertodev01/equations/wiki/Algebraic-equations), for solving polynomial equations
 - [Nonlinear equations](https://github.com/albertodev01/equations/wiki/Nonlinear-equations), for solving nonlinear equations
 - [Systems of equations](https://github.com/albertodev01/equations/wiki/Systems-of-equations), for solving systems of linear equations
 - [Utilities](https://github.com/albertodev01/equations/wiki/Utilities), for working with matrices, evaluating integrals, interpolating data, and more

Everything is exported by a single library:

```dart
import 'package:equations/equations.dart';
```

## Algebraic (polynomial) equations

Polynomials are represented by subtypes of the sealed `Algebraic` class:

| Degree | Type | Root-finding method |
|--------|------|---------------------|
| 0 | `Constant` | none |
| 1 | `Linear` | closed form |
| 2 | `Quadratic` | closed form |
| 3 | `Cubic` | closed form |
| 4 | `Quartic` | closed form |
| any | `GenericAlgebraic` | iterative (Durand-Kerner) |

Coefficients are `Complex` numbers, listed from the highest degree to the lowest. Every type also has a `realEquation` constructor that takes `double` values.

```dart
// f(x) = ix^3 + (-2 + 5i)x + 7
final equation = Cubic(
  a: const Complex.i(),
  c: const Complex(-2, 5),
  d: const Complex.fromReal(7),
);
final solutions = equation.solutions();

// -1.0447245173314326 + 1.779297792074603i
// 0.3113353509227148 - 2.7574534545940717i
// 0.7333891664087178 + 0.978155662519469i
solutions.forEach(print);
```

Besides finding roots, a polynomial can be evaluated, differentiated, factored, and used to solve inequalities:

```dart
// f(x) = x^2 - 3x + 2
final quadratic = Quadratic.realEquation(a: 1, b: -3, c: 2);

print(quadratic.discriminant()); // 1
print(quadratic.solutions()); // [2, 1]
print(quadratic.realEvaluateOn(5)); // 12
print(quadratic.derivative()); // f(x) = 2x + -3
print(quadratic.factor()); // [f(x) = 1x + -2, f(x) = 1x + -1]

// x^2 - 3x + 2 < 0
// [Interval(start: 1.0, end: 2.0, isInclusive: false)]
print(
  quadratic.solveInequality(inequalityType: AlgebraicInequalityType.lessThan),
);
```

When you don't know the degree in advance, use `Algebraic.from` or `Algebraic.fromReal`. They return the most specific type for the given coefficients. Polynomials also support the `+`, `-`, `*` and `/` operators:

```dart
print(Algebraic.fromReal([1, 0, -4]).runtimeType); // Quadratic
print(Algebraic.fromReal([1, 0, -1, 0, 0, 3]).runtimeType); // GenericAlgebraic

// (x^2 - 4) / (x - 2)
// (quotient: f(x) = 1x + 2, remainder: f(x) = 0)
print(Algebraic.fromReal([1, 0, -4]) / Algebraic.fromReal([1, -2]));
```

## Nonlinear equations

Nonlinear equations are subtypes of `NonLinear`. The function is a `String` in the `x` variable, so it can come straight from user input. The available root-finding algorithms are:

 - `Bisection`, `Brent`, `Chords`, `RegulaFalsi` and `Ridders`, which need an interval `[a, b]` where `f(a)` and `f(b)` have opposite signs;
 - `Secant`, which needs two starting points `a` and `b`;
 - `Newton` and `Steffensen`, which need a single starting point `x0`.

Each solver also accepts a `tolerance` and a `maxSteps` parameter. The `solve()` method returns a record with every guess the algorithm made, plus estimates of its convergence rate and efficiency:

```dart
// f(x) = x^e - cos(x)
final newtonRaphson = Newton(function: 'x^e-cos(x)', x0: 0.5);
final (:guesses, :convergence, :efficiency) = newtonRaphson.solve();

print(guesses.last); // 0.8560552934767535
print(guesses.length); // 6
print(convergence); // 1.9998869100930123 (Newton converges quadratically)
print(efficiency); // 1.1224514697994163
```

If you don't have a good starting point, a bracketing method is the safer choice:

```dart
// f(x) = x^3 - x - 2, which changes sign on [1, 2]
final brent = Brent(function: 'x^3-x-2', a: 1, b: 2);

print(brent.solve().guesses.last); // 1.5213797068045676
```

Functions are parsed by `ExpressionParser`, which supports `+`, `-`, `*`, `/`, `^`, functions such as `sqrt`, `abs`, `sin`, `cos`, `log` and constants such as `pi` and `e`. You can also use the parser directly:

```dart
print(const ExpressionParser().evaluateOn('sqrt(x)+2*x', 4)); // 10.0
```

> **Note:** Multiplication always needs the `*` symbol (write `2*x`, not `2x`), and negation binds more tightly than the power, so `-x^2` means `(-x)^2`. Write `-(x^2)` instead.

## Systems of equations

Systems of linear equations have the form `Ax = b`, where `A` is a square `RealMatrix` and `b` is the list of known values. The solvers are subtypes of `SystemSolver`:

 - **direct methods**: `GaussianElimination`, `LUSolver` and `CholeskySolver` (for symmetric positive-definite matrices);
 - **iterative methods**: `JacobiSolver`, `GaussSeidelSolver` and `SORSolver`, which accept an initial guess `x0` and work best with diagonally dominant matrices.

```dart
// [1.0, 0.0, 1.0 | 6.0]
// [0.0, 2.0, 0.0 | 5.0]
// [1.0, 0.0, 3.0 | -2.0]
final solver = LUSolver(
  matrix: RealMatrix.fromData(
    rows: 3,
    columns: 3,
    data: const [
      [1, 0, 1],
      [0, 2, 0],
      [1, 0, 3],
    ],
  ),
  knownValues: [6, 5, -2],
);
final solutions = solver.solve();

// 10.0
// 2.5
// -4.0
solutions.forEach(print);

// LUSolver can reuse its factorization with other known values
print(solver.solveFor([1, 2, 3])); // [0.0, 1.0, 1.0]
```

Iterative solvers return an approximation, so it's a good idea to check the residual norm `||Ax - b||`:

```dart
final sor = SORSolver(
  matrix: RealMatrix.fromData(
    rows: 3,
    columns: 3,
    data: const [
      [4, 1, 0],
      [1, 4, 1],
      [0, 1, 4],
    ],
  ),
  knownValues: [5, 6, 5],
  w: 1.25,
);
final result = sor.solve();

print(sor.isDiagonallyDominant()); // true
print(result); // [1.0000000000085585, 0.9999999999961493, 1.0000000000047482]
print(sor.computeResidualNorm(result)); // 3.4011845726858726e-11
```

## Utilities

### Matrices

`RealMatrix` and `ComplexMatrix` share the same API, which supports the usual operators (`+`, `-`, `*`, `/`), as well as determinants, inverses, eigenvalues and the LU, Cholesky, QR, SVD and eigen decompositions.

```dart
final matrix = RealMatrix.fromData(
  rows: 2,
  columns: 2,
  data: const [
    [2, 1],
    [1, 3],
  ],
);

print(matrix(0, 1)); // 1.0
print(matrix.determinant()); // 5.0
print(matrix.isSymmetric()); // true
print(matrix.characteristicPolynomial()); // f(x) = 1x^2 + -5x + 5
print(matrix.eigenvalues()); // [3.618033988749895, 1.381966011250105]

// [0.6000000000000001, -0.2]
// [-0.2, 0.4]
print(matrix.inverse());

// The decompositions return a list of matrices: [Q, R] in this case
final [q, r] = matrix.qrDecomposition();
```

### Complex numbers

`Complex` is an immutable type with arithmetic operators and common functions, such as `abs`, `conjugate`, `sqrt`, `pow`, `exp`, `log` and trigonometric functions.

```dart
const z = Complex(3, 4);
const w = Complex(1, -2);

print(z + w); // 4 + 2i
print(z * w); // 11 - 2i
print(z / w); // -1 + 2i
print(z.abs()); // 5.0
print(z.conjugate()); // 3 - 4i
print(z.sqrt()); // 2 + 1i
print(z.toStringAsFixed(2)); // 3.00 + 4.00i

// Fractions, from the 'fraction' package (re-exported by 'equations')
final fromFractions = Complex.fromFraction(Fraction(1, 2), Fraction(3, 4));
print(fromFractions.toStringAsFraction()); // 1/2 + 3/4i

// Polar form: r = 5.0, phi = 0.927... rad
print(z.toPolarCoordinates());
```

> **Note:** `nthRoot` returns the principal root, which is not always the real one. For example, `Complex.fromReal(-8).nthRoot(3)` returns `1 + 1.732...i`, not `-2`.

### Numerical integration

Integrals are computed by subtypes of `NumericalIntegration`. `MidpointRule`, `TrapezoidalRule`, `SimpsonRule`, `BooleRule` and `GaussLegendreRule` split the interval into a fixed number of `intervals`. `AdaptiveQuadrature` refines the parts of the interval where the function changes quickly, and is usually the most accurate choice.

```dart
// The exact value is -7.71303286111434...
const simpson = SimpsonRule(
  function: 'sin(x)*e^x',
  lowerBound: 2,
  upperBound: 4,
);
const adaptive = AdaptiveQuadrature(
  function: 'sin(x)*e^x',
  lowerBound: 2,
  upperBound: 4,
);

print(simpson.integrate().result); // -7.713030258466236
print(adaptive.integrate().result); // -7.713032861114337
```

### Interpolation

Interpolation types build a curve through a list of `InterpolationNode`s and evaluate it with `compute`. The available types are `LinearInterpolation` (exactly 2 nodes), `PolynomialInterpolation`, `NewtonInterpolation` and `SplineInterpolation`.

```dart
const nodes = [
  InterpolationNode(x: 0, y: 1),
  InterpolationNode(x: 1, y: 3),
  InterpolationNode(x: 2, y: 2),
  InterpolationNode(x: 3, y: 5),
];
const polynomial = PolynomialInterpolation(nodes: nodes);

print(polynomial.compute(1.5)); // 2.4375000000000004
print(const SplineInterpolation(nodes: nodes).compute(1.5)); // 2.5

// f(x) = 1.1666666666666667x^3 + -5x^2 + 5.833333333333334x + 1
print(polynomial.buildPolynomial());
```

## Error handling

When the input is invalid (for example, a singular matrix, a malformed expression or an interval that doesn't bracket a root), the package throws a subtype of `EquationException`, such as `AlgebraicException`, `NonlinearException`, `MatrixException` or `SystemSolverException`.

```dart
try {
  Bisection(function: 'x^2+1', a: -1, b: 1).solve();
} on NonlinearException catch (e) {
  // The root is not bracketed in [-1.0, 1.0]. f(a) and f(b) must have opposite signs.
  print(e.message);
}
```
