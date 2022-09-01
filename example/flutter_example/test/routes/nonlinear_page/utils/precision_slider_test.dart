import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../nonlinear_mock.dart';

void main() {
  group("Testing the 'PrecisionSlider' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockNonlinearWidget(
          child: PrecisionSlider(),
        ),
      );

      expect(find.byType(PrecisionSlider), findsOneWidget);
    });

    testWidgets(
      'Making sure that the slider has the exact initial position (at the '
      'middle of the range values).',
      (tester) async {
        await tester.pumpWidget(
          const MockNonlinearWidget(
            child: PrecisionSlider(),
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
      'Making sure that the slider can actually slide',
      (tester) async {
        await tester.pumpWidget(
          const MockNonlinearWidget(
            child: PrecisionSlider(),
          ),
        );

        final finder = find.byType(Slider);
        final slider = tester.firstWidget(finder) as Slider;
        expect(slider.value, equals(6));

        // State
        expect(find.text('1.0e-6'), findsOneWidget);
        expect(finder, findsOneWidget);

        // Moving the plot_zoom
        await tester.drag(finder, const Offset(-20, 0));
        expect(find.text('1.0e-8'), findsNothing);
      },
    );
  });

  group('Golden tests - PrecisionSlider', () {
    testWidgets('PrecisionSlider', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 200));

      await tester.pumpWidget(
        const MockNonlinearWidget(
          child: PrecisionSlider(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/precision_slider.png'),
      );
    });
  });
}
