<p align="center">
<img src="https://raw.githubusercontent.com/albertodev01/equations/6f15adbc96445c88ca02c7b85f4ae2b51f88e949/assets/equations_logo.svg" height="92" alt="dart_equations logo" />
</p>
<p align="center">An equation solving library written purely in Dart</p>
<p align="center">
    <a href="https://codecov.io/gh/albertodev01/equations"><img src="https://codecov.io/gh/albertodev01/equations/branch/master/graph/badge.svg?token=OQFZFHPD3S"/></a>
    <a href="https://github.com/albertodev01/equations/actions"><img src="https://github.com/albertodev01/equations/workflows/equations_ci/badge.svg" alt="CI status" /></a>
    <a href="https://github.com/albertodev01/equations/stargazers"><img src="https://img.shields.io/github/stars/albertodev01/equations.svg?style=flat&logo=github&colorB=blue&label=stars" alt="Stars count on GitHub" /></a>
  <a href="https://pub.dev/packages/equations"><img src="https://img.shields.io/pub/v/equations.svg?style=flat&logo=github&colorB=blue" alt="Stars count on GitHub" /></a>
</p>

---

Thanks to `equations` you're able to solve polynomial and nonlinear equations with ease. It's been written in "pure" Dart, meaning that it has no dependency on any framework. It can be used with Flutter for web, desktop and mobile. Here's a summary of the contents of the package:

  - `Algebraic` and all of its subtypes, which can be used to solve algebraic equations (also known as polynomial equations);
  - `Nonlinear` and all of its subtypes, which can be used to solve nonlinear equations;
  - `Complex`, which is used to easily handle complex numbers;
  - `Fraction`, from the [fraction](https://pub.dev/packages/fraction) package which helps you working with fractions.

This package is meant to be used with Dart 2.12 or higher because the code is entirely null safe!

# Algebraic equations

Use one of the following classes to find the roots of a specific type of polynomial. You can use complex numbers and fractions.

| Solver name |                                  Equation                                 |       Field       |
|:-----------:|:-------------------------------------------------------------------------:|:-----------------:|
| `Constant`  | <em>f(x) = a</em>                                                         | a ∈ C             |
| `Linear`    | <em>f(x) = ax + b</em>                                                    | a, b ∈ C          |
| `Quadratic` | <em>f(x) = ax<sup>2</sup> + bx + c</em>                                   | a, b, c ∈ C       |
| `Cubic`     | <em>f(x) = ax<sup>3</sup> + bx<sup>2</sup> + cx + d</em>                  | a, b, c, d ∈ C    |
| `Quartic`   | <em>f(x) = ax<sup>4</sup> + bx<sup>3</sup> + cx<sup>2</sup> + dx + e</em> | a, b, c, d, e ∈ C |

When solving a polynomial up to the fourth degree, prefer using one of these classes rather than guessing the roots with a root-finding algorithm (see below). Here's a simple example of how you can solve polynomial equations:

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
print("$equation");
// f(x) = (2 - 3i)x^3 + 6/5ix^2 + (5 - 1i)x + (-9 - 6i)
print(equation.toStringWithFractions());

/*
 * Prints the roots of the equation:
 *
 *  x1 = 0.348906207844 - 1.734303423032i
 *  x2 = -1.083892638909 + 0.961044482775
 *  x3 = 1.011909507988 + 0.588643555642
 * */
for (final root in equation.solutions()) {
  print(root);
}
```

There's a formula for polynomials up to the fourth degree, as explained by [Galois Theory](https://en.wikipedia.org/wiki/Galois_theory). If you wish to solve a polynomial whose degree is 5 (or higher), consider using a root-finding algorithm (see the [# Nonlinear equations] paragraph) or the Laguerre method.

# Nonlinear equations

Use one of the following classes, representing a root-finding algorithm, to find the roots of an equation. Only real numbers are allowed.

| Method name  |
|:------------:|
| `Bisection`  |
| `Chords`     |
| `Newton`     |
| `Secant`     |
| `Steffensen` |

Expressions are parsed using [math_expressions](https://pub.dev/packages/math_expressions), a very nice library that supports most of mathematical operators such as sine, cosine, tangent, logarithm and so on. Here's a simple example of how you can find the roots of an equation:

```dart
final newton = Newton("2*x+cos(x)", -1, maxSteps: 5);

final steps = newton.maxSteps; // 5
final tol = newton.tolerance; // 1.0e-10
final fx = newton.function; // 2*x+cos(x)
final guess = newton.x0; // -1

final solutions = await newton.solve();

final convergence = solutions.convergence.round(); // 2
final solutions = solutions.efficiency.round() // 1

/*
 * The getter `solutions.guesses` returns the list of values computed by the algorithm
 *
 * -0.4862880170389824
 * -0.45041860473199363
 * -0.45018362150211116
 * -0.4501836112948736
 * -0.45018361129487355
 */
final guesses = solutions.guesses;
```
