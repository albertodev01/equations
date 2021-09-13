import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing states for the 'IntegralBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      const guesses = IntegralResult(
        result: 10,
        numericalIntegration: SimpsonRule(
          function: 'x+1',
          lowerBound: 0,
          upperBound: 2,
        ),
      );

      expect(guesses.props.length, equals(2));

      expect(
        const IntegralResult(
          result: 10,
          numericalIntegration: SimpsonRule(
            function: 'x+1',
            lowerBound: 0,
            upperBound: 2,
          ),
        ),
        equals(guesses),
      );

      expect(
        const IntegralNone(),
        equals(const IntegralNone()),
      );

      expect(
        const IntegralError(),
        equals(const IntegralError()),
      );
    });
  });
}
