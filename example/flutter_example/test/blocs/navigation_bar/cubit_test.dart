import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NavigationCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = NavigationCubit();

      expect(bloc.state, isZero);
    });

    blocTest<NavigationCubit, int>(
      'Making sure that the bloc emits states',
      build: () => NavigationCubit(),
      act: (cubit) => cubit..pageIndex(1)..pageIndex(2),
      expect: () => const [1, 2],
      verify: (cubit) => cubit.state == 2,
    );
  });
}
