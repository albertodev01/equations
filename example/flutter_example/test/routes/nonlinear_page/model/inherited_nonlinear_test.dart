import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedNonlinear' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final inheritedNonlinear = InheritedNonlinear(
        nonlinearState: NonlinearState(NonlinearType.singlePoint),
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedNonlinear.updateShouldNotify(inheritedNonlinear),
        isFalse,
      );
      expect(
        inheritedNonlinear.updateShouldNotify(
          InheritedNonlinear(
            nonlinearState: NonlinearState(NonlinearType.singlePoint),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedNonlinear.updateShouldNotify(
          InheritedNonlinear(
            nonlinearState: NonlinearState(NonlinearType.singlePoint),
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
        late NonlinearState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedNonlinear(
              nonlinearState: NonlinearState(NonlinearType.singlePoint),
              child: Builder(
                builder: (context) {
                  reference = InheritedNonlinear.of(context).nonlinearState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.nonlinearType, equals(NonlinearType.singlePoint));
        expect(reference.state.nonlinear, isNull);
      },
    );
  });
}
