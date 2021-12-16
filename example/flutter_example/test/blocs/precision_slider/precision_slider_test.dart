import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/precision_slider/precision_slider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PrecisionSliderCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = PrecisionSliderCubit(
        minValue: 3,
        maxValue: 7,
      );

      expect(bloc.minValue, equals(3.0));
      expect(bloc.maxValue, equals(7.0));
      expect(bloc.state, equals(5));
    });

    blocTest<PrecisionSliderCubit, double>(
      'Making sure that the bloc emits states',
      build: () => PrecisionSliderCubit(
        minValue: 1,
        maxValue: 10,
      ),
      act: (cubit) => cubit
        ..updateSlider(5)
        ..updateSlider(6)
        ..updateSlider(9)
        ..updateSlider(9),
      expect: () => const [5, 6, 9],
      verify: (cubit) => cubit.state == 9,
    );

    blocTest<PrecisionSliderCubit, double>(
      "Making sure that the bloc doesn't emit states when the value is smaller "
      'than the lower bound.',
      build: () => PrecisionSliderCubit(
        minValue: 1,
        maxValue: 10,
      ),
      act: (cubit) => cubit
        ..updateSlider(1)
        ..updateSlider(0)
        ..updateSlider(2),
      expect: () => const [1, 2],
      verify: (cubit) => cubit.state == 2,
    );

    blocTest<PrecisionSliderCubit, double>(
      "Making sure that the bloc doesn't emit states when the value is bigger "
      'than the lower bound.',
      build: () => PrecisionSliderCubit(
        minValue: 1,
        maxValue: 10,
      ),
      act: (cubit) => cubit
        ..updateSlider(10)
        ..updateSlider(11)
        ..updateSlider(22),
      expect: () => const [10],
      verify: (cubit) => cubit.state == 10,
    );

    blocTest<PrecisionSliderCubit, double>(
      'Making sure that the bloc can be reset',
      build: () => PrecisionSliderCubit(
        minValue: 2,
        maxValue: 10,
      ),
      act: (cubit) => cubit
        ..updateSlider(4)
        ..updateSlider(9)
        ..reset()
        ..updateSlider(1),
      expect: () => const [4, 9, 6],
      verify: (cubit) => cubit.state == 6,
    );
  });
}
