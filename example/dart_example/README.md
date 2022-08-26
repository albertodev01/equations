This is a very simple Dart CLI app that shows how the `equations` package can be used to solve equations, evaluate integrals or analyze matrices. You can run the app using the following command from the project root:

```bash
 $ dart run equation_solver_cli <argument>
```

The `<argument>` can be one of the following:

 - `-p` to generate and solve random polynomial equations;
 - `-n` to solve nonlinear equations using various algorithms;
 - `-i` to evaluate an integral using various algorithms;
 - `-m` to analyze a matrix and solve a system with different decomposition strategies and algorithms.

If you want to create a portable binary file of this example (like an `.exe` file for Windows), see the [dart compile](https://dart.dev/tools/dart-compile) documentation.
