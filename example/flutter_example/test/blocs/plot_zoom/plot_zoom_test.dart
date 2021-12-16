import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PlotZoomCubit' cubit", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = PlotZoomCubit(
        minValue: 2,
        maxValue: 7,
        initial: 5,
      );

      expect(bloc.minValue, equals(2.0));
      expect(bloc.maxValue, equals(7.0));
      expect(bloc.state, equals(bloc.initial));
    });

    blocTest<PlotZoomCubit, double>(
      'Making sure that the bloc emits states',
      build: () => PlotZoomCubit(
        minValue: 1,
        maxValue: 10,
        initial: 4,
      ),
      act: (cubit) => cubit
        ..updateSlider(5)
        ..updateSlider(6)
        ..updateSlider(9)
        ..updateSlider(9),
      expect: () => const [5, 6, 9],
      verify: (cubit) => cubit.state == 9,
    );

    blocTest<PlotZoomCubit, double>(
      "Making sure that the bloc doesn't emit states when the value is smaller "
      'than the lower bound.',
      build: () => PlotZoomCubit(
        minValue: 1,
        maxValue: 10,
        initial: 4,
      ),
      act: (cubit) => cubit
        ..updateSlider(1)
        ..updateSlider(0)
        ..updateSlider(2),
      expect: () => const [1, 2],
      verify: (cubit) => cubit.state == 2,
    );

    blocTest<PlotZoomCubit, double>(
      "Making sure that the bloc doesn't emit states when the value is bigger "
      'than the lower bound.',
      build: () => PlotZoomCubit(
        minValue: 1,
        maxValue: 10,
        initial: 4,
      ),
      act: (cubit) => cubit
        ..updateSlider(10)
        ..updateSlider(11)
        ..updateSlider(22),
      expect: () => const [10],
      verify: (cubit) => cubit.state == 10,
    );

    blocTest<PlotZoomCubit, double>(
      'Making sure that the bloc can be reset',
      build: () => PlotZoomCubit(
        minValue: 1,
        maxValue: 10,
        initial: 4,
      ),
      act: (cubit) => cubit
        ..updateSlider(5)
        ..updateSlider(6)
        ..reset()
        ..updateSlider(1),
      expect: () => const [5, 6, 4, 1],
      verify: (cubit) => cubit.state == 1,
    );
  });
}
