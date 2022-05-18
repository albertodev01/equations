import 'package:equations_solver/routes/polynomial_page/model/polynomial_result.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PolynomialType' enum", () {
    test('Properties values', () {
      expect(PolynomialType.linear.coefficients, equals(2));
      expect(PolynomialType.quadratic.coefficients, equals(3));
      expect(PolynomialType.cubic.coefficients, equals(4));
      expect(PolynomialType.quartic.coefficients, equals(5));

      expect(PolynomialType.values.length, equals(4));
    });
  });

  group("Testing the 'PolynomialState' class", () {
    test('Initial values', () {
      final polynomialState = PolynomialState(PolynomialType.linear);

      expect(polynomialState.polynomialType, equals(PolynomialType.linear));
      expect(polynomialState.state, equals(const PolynomialResult()));
    });

    test('Making sure that equations can be solved and cleared', () {
      var count = 0;
      final polynomialState = PolynomialState(PolynomialType.linear)
        ..addListener(() => ++count);

      expect(polynomialState.polynomialType, equals(PolynomialType.linear));
      expect(polynomialState.state, equals(const PolynomialResult()));

      polynomialState.solvePolynomial(const ['1', '2']);

      expect(polynomialState.polynomialType, equals(PolynomialType.linear));
      expect(polynomialState.state.algebraic, isNotNull);
      expect(count, equals(1));

      polynomialState.clear();

      expect(polynomialState.polynomialType, equals(PolynomialType.linear));
      expect(polynomialState.state, equals(const PolynomialResult()));
      expect(count, equals(2));
    });

    test('Making sure that expections are handled', () {
      var count = 0;
      final polynomialState = PolynomialState(PolynomialType.linear)
        ..addListener(() => ++count);

      expect(polynomialState.polynomialType, equals(PolynomialType.linear));
      expect(polynomialState.state, equals(const PolynomialResult()));

      polynomialState.solvePolynomial(const ['', '']);

      expect(polynomialState.polynomialType, equals(PolynomialType.linear));
      expect(polynomialState.state.algebraic, isNull);
      expect(count, equals(1));
    });
  });
}
