import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/expansion_cubit/expansion_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'ExpansionCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = ExpansionCubit();

      expect(bloc.state, isFalse);
    });

    blocTest<ExpansionCubit, bool>(
      'Making sure that the bloc emits states',
      build: ExpansionCubit.new,
      act: (cubit) => cubit
        ..toggle()
        ..toggle()
        ..toggle(),
      expect: () => const [true, false, true],
      verify: (cubit) => cubit.state,
    );
  });
}
