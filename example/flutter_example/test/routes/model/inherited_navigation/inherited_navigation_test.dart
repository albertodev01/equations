import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedNavigation' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final valueNotifier = ValueNotifier<int>(0);

      final inheritedNavigation = InheritedNavigation(
        navigationIndex: valueNotifier,
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNavigation.updateShouldNotify(inheritedNavigation),
        isFalse,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedNavigation(
            navigationIndex: ValueNotifier<int>(0),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedNavigation(
            navigationIndex: ValueNotifier<int>(1),
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
        late ValueNotifier<int> reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedNavigation(
              navigationIndex: ValueNotifier<int>(1),
              child: Builder(
                builder: (context) {
                  reference = InheritedNavigation.of(context).navigationIndex;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.value, equals(1));
      },
    );
  });
}
