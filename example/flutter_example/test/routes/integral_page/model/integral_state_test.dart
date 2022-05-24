import 'package:equations/equations.dart';
import 'package:equations_solver/routes/integral_page/model/integral_result.dart';
import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'IntegralState' class", () {
    test('Initial values', () {
      final integralState = IntegralState();

      expect(integralState.state, equals(const IntegralResult()));
      expect(integralState.state.numericalIntegration, isNull);
    });

    test('Making sure that equations can be solved and cleared', () {
      var count = 0;
      final integralState = IntegralState()..addListener(() => ++count);

      expect(integralState.state, equals(const IntegralResult()));
      expect(integralState.state.numericalIntegration, isNull);

      integralState.solveIntegral(
        upperBound: '1',
        lowerBound: '2',
        function: 'x-3',
        intervals: 30,
        integralType: IntegralType.trapezoid,
      );

      expect(integralState.state.numericalIntegration, isA<TrapezoidalRule>());
      expect(count, equals(1));

      integralState.clear();

      expect(integralState.state, equals(const IntegralResult()));
      expect(integralState.state.numericalIntegration, isNull);
    });

    test('Making sure that exceptions are handled', () {
      var count = 0;
      final integralState = IntegralState()..addListener(() => ++count);
      expect(integralState.state, equals(const IntegralResult()));

      integralState.solveIntegral(
        upperBound: '',
        lowerBound: '',
        function: '',
        intervals: 30,
        integralType: IntegralType.trapezoid,
      );

      expect(integralState.state.numericalIntegration, isNull);
      expect(count, equals(1));
    });
  });
}
