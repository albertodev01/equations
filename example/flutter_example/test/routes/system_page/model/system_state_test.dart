import 'package:equations_solver/routes/system_page/model/system_result.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NonlinearType' enum", () {
    test('Properties values', () {
      expect(SystemType.values.length, equals(3));
      expect(RowReductionMethods.values.length, equals(1));
      expect(FactorizationMethods.values.length, equals(2));
      expect(IterativeMethods.values.length, equals(3));
    });
  });

  group("Testing the 'SystemState' class", () {
    test('Initial values', () {
      final systemState = SystemState(SystemType.iterative);

      expect(systemState.systemType, equals(SystemType.iterative));
      expect(systemState.state, equals(const SystemResult()));
    });

    test(
      'Making sure that systems can be solved and cleared using row reduction'
      ' methods',
      () {
        var count = 0;
        final systemState = SystemState(SystemType.iterative)
          ..addListener(() => ++count);

        expect(systemState.systemType, equals(SystemType.iterative));
        expect(systemState.state, equals(const SystemResult()));

        systemState.iterativeSolver(
          flatMatrix: ['1', '3', '2', '5'],
          knownValues: ['0', '-1'],
          size: 2,
          method: IterativeMethods.gaussSeidel,
        );

        expect(systemState.systemType, equals(SystemType.iterative));
        expect(systemState.state.systemSolver, isNotNull);
        expect(count, equals(1));

        systemState.clear();

        expect(systemState.systemType, equals(SystemType.iterative));
        expect(systemState.state.systemSolver, isNull);
        expect(count, equals(2));
      },
    );

    test(
      'Making sure that systems can be solved and cleared using iterative'
      ' methods',
      () {
        var count = 0;
        final systemState = SystemState(SystemType.rowReduction)
          ..addListener(() => ++count);

        expect(systemState.systemType, equals(SystemType.rowReduction));
        expect(systemState.state, equals(const SystemResult()));

        systemState.rowReductionSolver(
          flatMatrix: ['1', '3', '2', '5'],
          knownValues: ['0', '-1'],
          size: 2,
        );

        expect(systemState.systemType, equals(SystemType.rowReduction));
        expect(systemState.state.systemSolver, isNotNull);
        expect(count, equals(1));

        systemState.clear();

        expect(systemState.systemType, equals(SystemType.rowReduction));
        expect(systemState.state.systemSolver, isNull);
        expect(count, equals(2));
      },
    );

    test(
      'Making sure that systems can be solved and cleared using factorization'
      ' methods',
      () {
        var count = 0;
        final systemState = SystemState(SystemType.factorization)
          ..addListener(() => ++count);

        expect(systemState.systemType, equals(SystemType.factorization));
        expect(systemState.state, equals(const SystemResult()));

        systemState.factorizationSolver(
          flatMatrix: ['1', '3', '2', '5'],
          knownValues: ['0', '-1'],
          size: 2,
          method: FactorizationMethods.lu,
        );

        expect(systemState.systemType, equals(SystemType.factorization));
        expect(systemState.state.systemSolver, isNotNull);
        expect(count, equals(1));

        systemState.clear();

        expect(systemState.systemType, equals(SystemType.factorization));
        expect(systemState.state.systemSolver, isNull);
        expect(count, equals(2));
      },
    );
  });
}
