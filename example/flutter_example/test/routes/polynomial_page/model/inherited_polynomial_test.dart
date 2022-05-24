import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedPolynomial' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final inheritedPolynomial = InheritedPolynomial(
        polynomialState: PolynomialState(PolynomialType.linear),
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedPolynomial.updateShouldNotify(inheritedPolynomial),
        isFalse,
      );
      expect(
        inheritedPolynomial.updateShouldNotify(
          InheritedPolynomial(
            polynomialState: PolynomialState(PolynomialType.linear),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedPolynomial.updateShouldNotify(
          InheritedPolynomial(
            polynomialState: PolynomialState(PolynomialType.quadratic),
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
        late PolynomialState reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedPolynomial(
              polynomialState: PolynomialState(PolynomialType.linear),
              child: Builder(
                builder: (context) {
                  reference = InheritedPolynomial.of(context).polynomialState;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.polynomialType, equals(PolynomialType.linear));
        expect(reference.state.algebraic, isNull);
      },
    );
  });
}
