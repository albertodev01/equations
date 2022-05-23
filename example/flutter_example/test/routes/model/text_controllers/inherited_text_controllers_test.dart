import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedTextControllers' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final controllers = [TextEditingController()];

      final inheritedNavigation = InheritedTextControllers(
        textControllers: controllers,
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNavigation.updateShouldNotify(inheritedNavigation),
        isFalse,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          const InheritedTextControllers(
            textControllers: [],
            child: SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedTextControllers(
            textControllers: [TextEditingController()],
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
        late List<TextEditingController> reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedTextControllers(
              textControllers: [
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
              ],
              child: Builder(
                builder: (context) {
                  reference =
                      InheritedTextControllers.of(context).textControllers;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.length, equals(3));
      },
    );
  });
}
