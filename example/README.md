# Algebraic

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
print("${equation.toStringWithFractions()}");

/*
 * Prints the roots of the equation:
 *
 *  x1 = 0.348906207844 - 1.734303423032i
 *  x2 = -1.083892638909 + 0.961044482775
 *  x3 = 1.011909507988 + 0.588643555642
 * */
for (final root in equation.solutions()) print(root);
  print(root);
```

# Nonlinear

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

# Complex

```dart
final c1 = Complex(-2, 6);
final c2 = Complex.i();

final fromPolar = Complex.fromPolar(2, 60, angleInRadians: false);
final toPolar = Complex(5, -7).toPolarCoordinates();

final value1 = Complex(3, -5) + Complex(-8, 13);
final value2 = Complex(3, -5) - Complex(-8, 13);
final value3 = Complex(3, -5) * Complex(-8, 13);
final value4 = Complex(3, -5) / Complex(-8, 13);

final conj = Complex(3, 7).conjugate;
final recip = Complex(-3, 1).reciprocal;
final modulus = Complex(13, -5).abs;

final sin = conj.sin;
final cos = conj.cos;
final tan = conj.tan;

final sqrt = c2.sqrt;
final root3 = c2.nthRoot(3);
final root5 = c2.nthRoot(5);
```