import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'TextFieldValuesCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      expect(TextFieldValuesCubit().state, equals(const {}));
    });

    blocTest<TextFieldValuesCubit, Map<int, String>>(
      'Making sure that the bloc emits states',
      build: () => TextFieldValuesCubit(),
      act: (cubit) => cubit
        ..setValue(index: 1, value: 'A')
        ..setValue(index: 5, value: 'B'),
      expect: () => const [
        {1: 'A'},
        {1: 'A', 5: 'B'},
      ],
      verify: (cubit) {
        expect(cubit.getValue(1), equals('A'));
        expect(cubit.getValue(5), equals('B'));
      },
    );

    blocTest<TextFieldValuesCubit, Map<int, String>>(
      'Making sure that the bloc can be cleared',
      build: () => TextFieldValuesCubit(),
      act: (cubit) => cubit
        ..setValue(index: 1, value: 'A')
        ..setValue(index: 5, value: 'B')
        ..reset()
        ..setValue(index: 2, value: 'C'),
      expect: () => const [
        {1: 'A'},
        {1: 'A', 5: 'B'},
        {},
        {2: 'C'},
      ],
    );

    blocTest<TextFieldValuesCubit, Map<int, String>>(
      'Making sure that values are updated when the index is the same',
      build: () => TextFieldValuesCubit(),
      act: (cubit) => cubit
        ..setValue(index: 1, value: 'A')
        ..setValue(index: 1, value: 'B')
        ..setValue(index: 2, value: 'A'),
      expect: () => const [
        {1: 'A'},
        {1: 'B'},
        {1: 'B', 2: 'A'},
      ],
    );

    blocTest<TextFieldValuesCubit, Map<int, String>>(
      'Making sure that, when asking for a non-existing key, an empty string '
      'is returned',
      build: () => TextFieldValuesCubit(),
      act: (cubit) => cubit..setValue(index: 1, value: 'A'),
      expect: () => const [
        {1: 'A'},
      ],
      verify: (cubit) {
        expect(cubit.getValue(1), equals('A'));
        expect(cubit.getValue(2), equals(''));
      },
    );
  });
}
