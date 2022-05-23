import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/models/system_text_controllers/system_text_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedTextControllers' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final systemControllers = SystemTextControllers(
        matrixControllers: [
          TextEditingController(),
        ],
        vectorControllers: [
          TextEditingController(),
        ],
        jacobiControllers: [
          TextEditingController(),
        ],
        wSorController: TextEditingController(),
      );

      final inheritedNavigation = InheritedSystemControllers(
        systemTextControllers: systemControllers,
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNavigation.updateShouldNotify(inheritedNavigation),
        isFalse,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedSystemControllers(
            systemTextControllers: SystemTextControllers(
              matrixControllers: [
                TextEditingController(),
              ],
              vectorControllers: [
                TextEditingController(),
              ],
              jacobiControllers: [
                TextEditingController(),
              ],
              wSorController: TextEditingController(),
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNavigation.updateShouldNotify(
          InheritedSystemControllers(
            systemTextControllers: SystemTextControllers(
              matrixControllers: [
                TextEditingController(),
              ],
              vectorControllers: [],
              jacobiControllers: [
                TextEditingController(),
              ],
              wSorController: TextEditingController(),
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
        late SystemTextControllers reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedSystemControllers(
              systemTextControllers: SystemTextControllers(
                matrixControllers: [
                  TextEditingController(),
                ],
                vectorControllers: [
                  TextEditingController(),
                ],
                jacobiControllers: [
                  TextEditingController(),
                ],
                wSorController: TextEditingController(),
              ),
              child: Builder(
                builder: (context) {
                  reference = InheritedSystemControllers.of(context)
                      .systemTextControllers;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.matrixControllers.length, equals(1));
        expect(reference.vectorControllers.length, equals(1));
        expect(reference.jacobiControllers.length, equals(1));
        expect(reference.wSorController, isNotNull);
      },
    );
  });
}
