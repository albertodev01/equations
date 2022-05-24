import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedSystem' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final inheritedNonlinear = InheritedSystem(
        systemState: SystemState(SystemType.rowReduction),
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNonlinear.updateShouldNotify(inheritedNonlinear),
        isFalse,
      );
      expect(
        inheritedNonlinear.updateShouldNotify(
          InheritedSystem(
            systemState: SystemState(SystemType.rowReduction),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNonlinear.updateShouldNotify(
          InheritedSystem(
            systemState: SystemState(SystemType.rowReduction),
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
        late SystemState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedSystem(
              systemState: SystemState(SystemType.rowReduction),
              child: Builder(
                builder: (context) {
                  reference = InheritedSystem.of(context).systemState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.systemType, equals(SystemType.rowReduction));
        expect(reference.state.systemSolver, isNull);
      },
    );
  });
}
