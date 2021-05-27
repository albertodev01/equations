import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing states for the 'NonlinearBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      const guesses = NonlinearGuesses(
        nonLinear: Newton(function: 'x - 2', x0: 2),
        nonlinearResults: NonlinearResults(
          guesses: [1, 2, 3],
          convergence: 1,
          efficiency: 2,
        ),
      );

      expect(guesses.props.length, equals(2));

      expect(
        const NonlinearGuesses(
          nonLinear: Newton(function: 'x - 2', x0: 2),
          nonlinearResults: NonlinearResults(
            guesses: [1, 2, 3],
            convergence: 1,
            efficiency: 2,
          ),
        ),
        equals(guesses),
      );

      expect(
        const NonlinearNone(),
        equals(const NonlinearNone()),
      );

      expect(
        const NonlinearError(),
        equals(const NonlinearError()),
      );
    });
  });
}
