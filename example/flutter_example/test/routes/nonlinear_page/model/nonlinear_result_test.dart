import 'package:equations/equations.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NonlinearResult' class", () {
    test('Initial values', () {
      const nonlinearResult = NonlinearResult(
        nonlinear: Newton(
          function: 'x-2',
          x0: 2,
        ),
      );

      expect(nonlinearResult.nonlinear, isA<Newton>());
    });

    test('Making sure that objects can be properly compared', () {
      const nonlinearResult = NonlinearResult(
        nonlinear: Newton(
          function: 'x-2',
          x0: 2,
        ),
      );

      expect(
        nonlinearResult,
        equals(
          const NonlinearResult(
            nonlinear: Newton(
              function: 'x-2',
              x0: 2,
            ),
          ),
        ),
      );

      expect(
        const NonlinearResult(
          nonlinear: Newton(
            function: 'x-2',
            x0: 2,
          ),
        ),
        nonlinearResult,
      );

      expect(
        nonlinearResult ==
            const NonlinearResult(
              nonlinear: Newton(
                function: 'x-2',
                x0: 2,
              ),
            ),
        isTrue,
      );

      expect(
        const NonlinearResult(
              nonlinear: Newton(
                function: 'x-2',
                x0: 2,
              ),
            ) ==
            nonlinearResult,
        isTrue,
      );

      expect(
        const NonlinearResult(
              nonlinear: Newton(
                function: 'x-2',
                x0: 2.1,
              ),
            ) ==
            nonlinearResult,
        isFalse,
      );

      expect(
        nonlinearResult.hashCode,
        equals(
          const NonlinearResult(
            nonlinear: Newton(
              function: 'x-2',
              x0: 2,
            ),
          ).hashCode,
        ),
      );
    });
  });
}
