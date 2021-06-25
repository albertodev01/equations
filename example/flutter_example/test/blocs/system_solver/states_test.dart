import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing events for the 'SystemBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      final systemGuesses = SystemGuesses(
        systemSolver: LUSolver.flatMatrix(
          equations: const [],
          constants: const [],
        ),
        solution: const [],
      );

      expect(systemGuesses.props.length, equals(2));

      expect(
        SystemGuesses(
          systemSolver: LUSolver.flatMatrix(
            equations: const [],
            constants: const [],
          ),
          solution: const [],
        ),
        equals(systemGuesses),
      );

      expect(
        const SystemError(),
        equals(const SystemError()),
      );

      expect(
        const SystemNone(),
        equals(const SystemNone()),
      );

      expect(
        const SingularSystemError(),
        equals(const SingularSystemError()),
      );
    });
  });
}
