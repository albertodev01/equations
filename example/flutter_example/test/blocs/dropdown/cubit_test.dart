import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'DropdownCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = DropdownCubit(
        initialValue: 'initial',
      );

      expect(bloc.state, equals('initial'));
    });

    blocTest<DropdownCubit, String>(
      'Making sure that the bloc emits states',
      build: () => DropdownCubit(initialValue: '0'),
      act: (cubit) => cubit
        ..changeValue('1')
        ..changeValue('2'),
      expect: () => const ['1', '2'],
      verify: (cubit) => cubit.state == '2',
    );

    blocTest<DropdownCubit, String>(
      'Making sure that the bloc emits states',
      build: () => DropdownCubit(initialValue: '0'),
      act: (cubit) => cubit
        ..changeValue('1')
        ..changeValue('2'),
      expect: () => const ['1', '2'],
      verify: (cubit) => cubit.state == '2',
    );
  });
}
