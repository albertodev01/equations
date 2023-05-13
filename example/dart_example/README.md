## Example

This is a simple Dart CLI application that shows how the `equations` package can be used to solve equations, evaluate integrals or analyze matrices. You can run it using:

```bash
 $ dart run equation_solver_cli <argument>
```

from the `example/dart_example/` folder. The `<argument>` can be one of the following:

 - `-p` to generate and solve random polynomial equations;
 - `-n` to solve nonlinear equations using various algorithms;
 - `-i` to evaluate an integral using various algorithms;
 - `-m` to analyze a matrix and solve a system with different decomposition strategies and algorithms.

If you want to create a portable binary file of this example (like an .exe file for Windows), see the dart compile documentation for more info.
