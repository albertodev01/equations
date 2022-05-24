import 'package:equations/equations.dart';
import 'package:equations_solver/routes/integral_page/model/integral_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'IntegralResult' class", () {
    test('Initial values', () {
      const integralResult = IntegralResult(
        numericalIntegration: SimpsonRule(
          function: 'x-2',
          lowerBound: 1,
          upperBound: 2,
        ),
      );

      expect(integralResult.numericalIntegration, isA<SimpsonRule>());
    });

    test('Making sure that objects can be properly compared', () {
      const integralResult = IntegralResult(
        numericalIntegration: SimpsonRule(
          function: 'x-2',
          lowerBound: 1,
          upperBound: 2,
        ),
      );

      expect(
        integralResult,
        equals(
          const IntegralResult(
            numericalIntegration: SimpsonRule(
              function: 'x-2',
              lowerBound: 1,
              upperBound: 2,
            ),
          ),
        ),
      );

      expect(
        const IntegralResult(
          numericalIntegration: SimpsonRule(
            function: 'x-2',
            lowerBound: 1,
            upperBound: 2,
          ),
        ),
        integralResult,
      );

      expect(
        integralResult ==
            const IntegralResult(
              numericalIntegration: SimpsonRule(
                function: 'x-2',
                lowerBound: 1,
                upperBound: 2,
              ),
            ),
        isTrue,
      );

      expect(
        const IntegralResult(
              numericalIntegration: SimpsonRule(
                function: 'x-2',
                lowerBound: 1,
                upperBound: 2,
              ),
            ) ==
            integralResult,
        isTrue,
      );

      expect(
        const IntegralResult(
              numericalIntegration: SimpsonRule(
                function: 'x-1',
                lowerBound: 1,
                upperBound: 2,
              ),
            ) ==
            integralResult,
        isFalse,
      );

      expect(
        integralResult.hashCode,
        equals(
          const IntegralResult(
            numericalIntegration: SimpsonRule(
              function: 'x-2',
              lowerBound: 1,
              upperBound: 2,
            ),
          ).hashCode,
        ),
      );
    });
  });
}
