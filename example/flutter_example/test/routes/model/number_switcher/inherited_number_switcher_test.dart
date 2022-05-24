import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedNavigation' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final numberSwitcher = NumberSwitcherState(
        min: 1,
        max: 10,
      );

      final inheritedNavigation = InheritedNumberSwitcher(
        numberSwitcherState: numberSwitcher,
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNavigation.updateShouldNotify(inheritedNavigation),
        isFalse,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedNumberSwitcher(
            numberSwitcherState: NumberSwitcherState(
              min: 1,
              max: 10,
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedNumberSwitcher(
            numberSwitcherState: NumberSwitcherState(
              min: 1,
              max: 3,
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
        late NumberSwitcherState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedNumberSwitcher(
              numberSwitcherState: NumberSwitcherState(
                min: 1,
                max: 3,
              ),
              child: Builder(
                builder: (context) {
                  reference =
                      InheritedNumberSwitcher.of(context).numberSwitcherState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.min, equals(1));
        expect(reference.max, equals(3));
        expect(reference.state, equals(1));
      },
    );
  });
}
