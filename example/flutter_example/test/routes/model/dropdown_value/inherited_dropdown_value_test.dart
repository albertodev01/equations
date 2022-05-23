import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'InheritedPolynomial' widget", () {
    test("Making sure that 'updateShouldNotify' is correctly overridden", () {
      final valueNotifier = ValueNotifier<String>('test');

      final inheritedDropdown = InheritedDropdownValue(
        dropdownValue: valueNotifier,
        child: const SizedBox.shrink(),
      );

      expect(
        inheritedDropdown.updateShouldNotify(inheritedDropdown),
        isFalse,
      );
      expect(
        inheritedDropdown.updateShouldNotify(
          InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>('test'),
            child: const SizedBox.shrink(),
          ),
        ),
        isTrue,
      );
      expect(
        inheritedDropdown.updateShouldNotify(
          InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(''),
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
        late ValueNotifier<String> reference;

        await tester.pumpWidget(
          MaterialApp(
            home: InheritedDropdownValue(
              dropdownValue: ValueNotifier<String>('test'),
              child: Builder(
                builder: (context) {
                  reference = InheritedDropdownValue.of(context).dropdownValue;

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        expect(reference.value, equals('test'));
      },
    );
  });
}
