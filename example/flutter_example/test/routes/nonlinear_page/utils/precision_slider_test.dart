import 'package:equations_solver/blocs/precision_slider/precision_slider.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PrecisionSlider' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: BlocProvider<PrecisionSliderCubit>(
            create: (_) => PrecisionSliderCubit(
              minValue: 1,
              maxValue: 10,
            ),
            child: const Scaffold(
              body: PrecisionSlider(),
            ),
          ),
        ),
      );

      expect(find.byType(PrecisionSlider), findsOneWidget);
    });

    testWidgets(
      'Making sure that when the plot_zoom has the same initial position defined '
      'by the state of the bloc.',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<PrecisionSliderCubit>(
              create: (_) => PrecisionSliderCubit(
                minValue: 2,
                maxValue: 10,
              ),
              child: const Scaffold(
                body: PrecisionSlider(),
              ),
            ),
          ),
        );

        final finder = find.byType(Slider);
        final slider = tester.firstWidget(finder) as Slider;
        expect(slider.value, equals(6));

        // State
        expect(find.text('1.0e-6'), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the plot_zoom updates the bloc state when its initial '
      'value changes',
      (tester) async {
        final bloc = PrecisionSliderCubit(
          minValue: 2,
          maxValue: 10,
        );

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<PrecisionSliderCubit>.value(
              value: bloc,
              child: const Scaffold(
                body: PrecisionSlider(),
              ),
            ),
          ),
        );

        expect(find.byType(Slider), findsOneWidget);
        expect(bloc.state, equals(6));

        // Moving the plot_zoom
        await tester.drag(find.byType(Slider), const Offset(-10, 0));
        expect(bloc.state.round(), equals(8));
      },
    );

    testGoldens('PrecisionSlider', (tester) async {
      final widget = SizedBox(
        width: 300,
        height: 90,
        child: Scaffold(
          body: BlocProvider<PrecisionSliderCubit>(
            create: (_) => PrecisionSliderCubit(
              minValue: 1,
              maxValue: 10,
            ),
            child: const PrecisionSlider(),
          ),
        ),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(350, 150),
      );
      await screenMatchesGolden(tester, 'precision_slider');
    });
  });
}
