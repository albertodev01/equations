import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../integral_mock.dart';

void main() {
  group("Testing the 'IntegralDropdownSelection' widget", () {
    test(
      "Making sure that an 'IntegralDropdownItemsExt' is correctly converted "
      'into a string',
      () {
        expect(IntegralDropdownItems.simpson.asString(), equals('Simpson'));
        expect(IntegralDropdownItems.trapezoid.asString(), equals('Trapezoid'));
        expect(IntegralDropdownItems.midpoint.asString(), equals('Midpoint'));
      },
    );

    test(
      "Making sure that an 'IntegralDropdownItemsExt' can correctly be "
      'generated from a string',
      () {
        expect(
          'simpson'.toIntegralDropdownItems(),
          equals(IntegralDropdownItems.simpson),
        );
        expect(
          'trapezoid'.toIntegralDropdownItems(),
          equals(IntegralDropdownItems.trapezoid),
        );
        expect(
          'midpoint'.toIntegralDropdownItems(),
          equals(IntegralDropdownItems.midpoint),
        );

        expect(
          () => 'a'.toIntegralDropdownItems(),
          throwsArgumentError,
        );
      },
    );

    testWidgets(
      'Making sure that the dropdown items can be changed',
      (tester) async {
        await tester.pumpWidget(
          mockIntegralWidget(
            child: const IntegralDropdownSelection(),
          ),
        );

        // Initial value
        expect(
          find.text(IntegralDropdownItems.simpson.asString()),
          findsOneWidget,
        );

        // Changing the value
        await tester.tap(
          find.byKey(const Key('Integral-Dropdown-Button-Selection')),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('Midpoint-Dropdown')).last,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        // Verifying the new dropdown state
        expect(
          find.text(IntegralDropdownItems.midpoint.asString()),
          findsOneWidget,
        );
        expect(find.text('Midpoint'), findsOneWidget);

        // Changing the value again
        await tester.tap(
          find.byKey(const Key('Integral-Dropdown-Button-Selection')),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('Trapezoid-Dropdown')).last,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        // Verifying the new dropdown state
        expect(
          find.text(IntegralDropdownItems.trapezoid.asString()),
          findsOneWidget,
        );
        expect(find.text('Trapezoid'), findsOneWidget);
      },
    );
  });

  group('Golden tests - IntegralDropdownSelection', () {
    testWidgets('IntegralDropdownSelection - simpson', (tester) async {
      await tester.pumpWidget(
        mockIntegralWidget(
          dropdownValue: IntegralDropdownItems.simpson.asString(),
          child: const IntegralDropdownSelection(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/dropdown_selection_simpson.png'),
      );
    });

    testWidgets('IntegralDropdownSelection - midpoint', (tester) async {
      await tester.pumpWidget(
        mockIntegralWidget(
          dropdownValue: IntegralDropdownItems.midpoint.asString(),
          child: const IntegralDropdownSelection(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/dropdown_selection_midpoint.png'),
      );
    });

    testWidgets('IntegralDropdownSelection - trapezoid', (tester) async {
      await tester.pumpWidget(
        mockIntegralWidget(
          dropdownValue: IntegralDropdownItems.trapezoid.asString(),
          child: const IntegralDropdownSelection(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/dropdown_selection_trapezoid.png'),
      );
    });
  });
}
