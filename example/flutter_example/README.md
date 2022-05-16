# Equations solver

An equation solving application created with the Flutter framework that can run on Android, iOS, Windows, macOS, Linux and web. This project shows how the `equations` package can be used to solve equations, systems, integrals and much more. The app fully localized and it currently supports the following languages:

  - English
  - Italian
  - French

If you wish to add more languages, please create a new `app_xx.arb` file (replace `xx` with the language code) inside `lib/localization` and submit a PR! :rocket:

<p align="center"><img src="https://raw.githubusercontent.com/albertodev01/equations/master/assets/circle_logo.svg" alt="Equation Solver logo" width="55" height="55" /></p>
<p align="center"><a href="https://albertodev01.github.io/equations/">Equation Solver - Flutter web demo</a></p>

If you want to play with this code in your machine, make sure to have Dart 2.17.0 (or greater) and Flutter 3.0.0 (or greater) installed. If you aren't on Windows, running tests with `flutter test` will fail because of goldens. For any other OS different from Windows, simply use `flutter test --update-goldens` once to fix the goldens and have your tests to correctly execute.