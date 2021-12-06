import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'DropdownCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = SliderCubit(
        minValue: 1,
        maxValue: 10,
        initial: 5,
      );

      expect(bloc.state, equals(5));
      expect(bloc.minValue, equals(1));
      expect(bloc.maxValue, equals(10));
    });

    blocTest<SliderCubit, double>(
      'Making sure that the bloc emits states',
      build: () => SliderCubit(
        minValue: 1,
        maxValue: 10,
        initial: 5,
      ),
      act: (cubit) => cubit
        ..updateSlider(1)
        ..updateSlider(10)
        ..updateSlider(12)
        ..updateSlider(6),
      expect: () => const [1, 10, 6],
    );

    blocTest<SliderCubit, double>(
      'Making sure that the bloc can be resetted',
      build: () => SliderCubit(
        minValue: 1,
        maxValue: 10,
        initial: 5,
      ),
      act: (cubit) => cubit
        ..updateSlider(1)
        ..updateSlider(10)
        ..reset(),
      expect: () => const [1, 10, 5],
    );
  });
}
