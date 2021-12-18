import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing events for the 'IntegralBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      const guesses = IntegralSolve(
        intervals: 6,
        integralType: IntegralType.trapezoid,
        upperBound: '1',
        lowerBound: '2',
        function: 'x',
      );

      expect(guesses.props.length, equals(5));

      expect(
        const IntegralSolve(
          intervals: 6,
          integralType: IntegralType.trapezoid,
          upperBound: '1',
          lowerBound: '2',
          function: 'x',
        ),
        equals(guesses),
      );

      expect(
        const IntegralClean(),
        equals(const IntegralClean()),
      );

      expect(const IntegralClean().props.length, isZero);
    });
  });
}
