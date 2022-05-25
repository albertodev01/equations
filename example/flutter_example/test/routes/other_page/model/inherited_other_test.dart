import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedNonlinear' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final inheritedOther = InheritedOther(
        otherState: OtherState(),
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedOther.updateShouldNotify(inheritedOther),
        isFalse,
      );
      expect(
        inheritedOther.updateShouldNotify(
          InheritedOther(
            otherState: OtherState(),
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
        late OtherState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedOther(
              otherState: OtherState(),
              child: Builder(
                builder: (context) {
                  reference = InheritedOther.of(context).otherState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.state.results, isNull);
      },
    );
  });
}
