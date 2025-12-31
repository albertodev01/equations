# Examples

Here is a quick overview of the main features of the `equations` package. For more information about solving equations and examples on how to use the classes from this package, see the articles on the repository's Wiki pages:

 - [Algebraic equations](https://github.com/albertodev01/equations/wiki/Algebraic-equations), for solving polynomial equations;
 - [Nonlinear equations](https://github.com/albertodev01/equations/wiki/Nonlinear-equations), for solving nonlinear equations;
 - [Systems of equations](https://github.com/albertodev01/equations/wiki/Systems-of-equations), for solving systems of equations;
 - [Utilities](https://github.com/albertodev01/equations/wiki/Utilities), for working with matrices, evaluating integrals, interpolating data, and more.

## Algebraic (Polynomial) equations

```dart
// f(x) = ix^3 + (-2 + 5i)x + 7
final equation = Cubic(
  a: const Complex.i(),
  c: const Complex(-2, 5),
  d: const Complex.fromReal(7),
);
final solutions = equation.solutions();

/// -1.0447245173314328 + 1.7792977920746025i 
/// 0.3113353509227148 - 2.7574534545940717i
/// 0.733389166408717 + 0.9781556625194701i
print(solutions);
```

## Nonlinear equations

```dart
// f(x) = x^e - cos(x)
final newtonRaphson = Newton(function: 'x^e-cos(x)', x0: 0.5)
final result = newtonRaphson.solve();

// 0.856055...
print(result.guesses.last);
```

## Systems of equations

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
print(solutions);
```