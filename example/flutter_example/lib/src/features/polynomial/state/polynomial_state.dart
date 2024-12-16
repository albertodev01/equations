import 'package:equations/equations.dart';
import 'package:equations_solver/src/features/app/widgets/inherited_object.dart';
import 'package:flutter/material.dart';

enum PolynomialTabState {
  ready,
  error,
}

class PolynomialState extends ChangeNotifier {
  final int degree;

  PolynomialState({
    required this.degree,
  });

  var _solutions = const <Complex>[];
  var _discriminant = const Complex.zero();
  var _tabState = PolynomialTabState.ready;

  List<Complex> get solutions => _solutions;
  Complex get discriminant => _discriminant;
  PolynomialTabState get tabState => _tabState;

  void solve({required List<String> coefficients}) {
    try {
      final parsedCoefficients = _parseCoefficients(coefficients);
      final algebraic = Algebraic.from(parsedCoefficients);

      _solutions = algebraic.solutions();
      _discriminant = algebraic.discriminant();
      _tabState = PolynomialTabState.ready;

      notifyListeners();
    } on Exception {
      clear(
        tabState: PolynomialTabState.error,
      );
    }
  }

  void clear({
    PolynomialTabState tabState = PolynomialTabState.ready,
  }) {
    _solutions = const <Complex>[];
    _discriminant = const Complex.zero();
    _tabState = tabState;
    notifyListeners();
  }

  /// Converts a list of strings into a list of numbers, if possible.
  List<Complex> _parseCoefficients(List<String> rawInput) {
    // Fractions are accepted so this method throws only if the given string is
    // NOT a number or a string
    const parser = ExpressionParser();

    return rawInput.map<Complex>((value) {
      if (!value.isNumericalExpression) {
        throw FormatException('"$value" is not a valid number.');
      }
      return Complex.fromReal(parser.evaluate(value));
    }).toList(growable: false);
  }
}

extension PolynomialStateExtension on BuildContext {
  PolynomialState get polynomialState =>
      InheritedObject.of<PolynomialState>(this).object;
}
