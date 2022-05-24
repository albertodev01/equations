import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedIntegral' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final inheritedIntegral = InheritedIntegral(
        integralState: IntegralState(),
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedIntegral.updateShouldNotify(inheritedIntegral),
        isFalse,
      );
      expect(
        inheritedIntegral.updateShouldNotify(
          InheritedIntegral(
            integralState: IntegralState(),
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
        late IntegralState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedIntegral(
              integralState: IntegralState(),
              child: Builder(
                builder: (context) {
                  reference = InheritedIntegral.of(context).integralState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.state, isNotNull);
      },
    );
  });
}
