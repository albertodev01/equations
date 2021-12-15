import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NumberSwitcherCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = NumberSwitcherCubit(
        min: 2,
        max: 7,
      );

      expect(bloc.state, equals(2));
      expect(bloc.min, equals(2));
      expect(bloc.max, equals(7));
      expect(bloc.state, equals(bloc.min));
    });

    blocTest<NumberSwitcherCubit, int>(
      'Making sure that the bloc emits states',
      build: () => NumberSwitcherCubit(
        min: 2,
        max: 7,
      ),
      act: (cubit) => cubit
        ..increase()
        ..increase()
        ..decrease(),
      expect: () => const [3, 4, 3],
      verify: (cubit) => cubit.state == 2,
    );

    blocTest<NumberSwitcherCubit, int>(
      "Making sure that the bloc doesn't emit states when the lower bound "
      'is reached.',
      build: () => NumberSwitcherCubit(
        min: 2,
        max: 3,
      ),
      act: (cubit) => cubit
        ..increase()
        ..decrease()
        ..decrease(),
      expect: () => const [3, 2],
      verify: (cubit) => cubit.state == 2,
    );

    blocTest<NumberSwitcherCubit, int>(
      "Making sure that the bloc doesn't emit states when the upper bound "
      'is reached.',
      build: () => NumberSwitcherCubit(
        min: 2,
        max: 2,
      ),
      act: (cubit) => cubit
        ..increase()
        ..increase()
        ..increase()
        ..increase(),
      expect: () => const [],
      verify: (cubit) => cubit.state == 2,
    );

    blocTest<NumberSwitcherCubit, int>(
      'Making sure that the bloc can be reset',
      build: () => NumberSwitcherCubit(
        min: 2,
        max: 7,
      ),
      act: (cubit) => cubit
        ..increase()
        ..increase()
        ..decrease()
        ..reset(),
      expect: () => const [3, 4, 3, 2],
      verify: (cubit) => cubit.state == 2,
    );
  });
}
