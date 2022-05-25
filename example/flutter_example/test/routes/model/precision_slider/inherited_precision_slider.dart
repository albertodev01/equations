import 'package:equations_solver/routes/models/precision_slider/inherited_precision_slider.dart';
import 'package:equations_solver/routes/models/precision_slider/precision_slider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedPrecisionSlider' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final precisionSlider = PrecisionSliderState(
        minValue: 1,
        maxValue: 8,
      );

      final inheritedNavigation = InheritedPrecisionSlider(
        precisionState: precisionSlider,
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNavigation.updateShouldNotify(inheritedNavigation),
        isFalse,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedPrecisionSlider(
            precisionState: PrecisionSliderState(
              minValue: 1,
              maxValue: 8,
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedPrecisionSlider(
            precisionState: PrecisionSliderState(
              minValue: 2,
              maxValue: 8,
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
    });

    testWidgets(
      "Making sure that the static 'of' method doesn't throw when located up "
      'in the tree',
      (tester) async {
        late PrecisionSliderState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedPrecisionSlider(
              precisionState: PrecisionSliderState(
                minValue: 2,
                maxValue: 8,
              ),
              child: Builder(
                builder: (context) {
                  reference =
                      InheritedPrecisionSlider.of(context).precisionState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.minValue, equals(1));
        expect(reference.maxValue, equals(5));
      },
    );
  });
}
