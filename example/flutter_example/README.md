# Equations solver

An equation-solving application created with Flutter that can run on Android, iOS, Windows, macOS, Linux, and the web. This project shows how the `equations` package is used to solve equations, systems, integrals, and much more. The application currently supports the following languages:

  - English
  - Italian
  - French

If you wish to add more languages, please create a new `app_xx.arb` file (replace `xx` with the language code) inside `lib/localization` and submit a PR! :rocket:

<p align="center"><img src="https://raw.githubusercontent.com/albertodev01/equations/master/assets/circle_logo.svg" alt="Equation Solver logo" width="55" height="55" /></p>
<p align="center"><a href="https://albertodev01.github.io/equations/">Equation Solver - Flutter web demo</a></p>

If you want to play with this code on your machine, make sure to have Dart 3.0. (or greater) and Flutter 3.10.0 (or greater) installed. If you aren't using Windows 10, running tests with `flutter test` could fail because of golden tests. For any OS different from Windows, simply use `flutter test --update-goldens` once to refresh goldens and have your tests correctly executed.
