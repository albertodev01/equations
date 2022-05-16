import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

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
        final cubit = DropdownCubit(
          initialValue: IntegralDropdownItems.simpson.asString(),
        );

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<DropdownCubit>.value(
              value: cubit,
              child: const Scaffold(
                body: IntegralDropdownSelection(),
              ),
            ),
          ),
        );

        // Initial value
        expect(cubit.state, equals('Simpson'));
        expect(find.text('Simpson'), findsOneWidget);

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
        expect(cubit.state, equals('Midpoint'));
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
        expect(cubit.state, equals('Trapezoid'));
        expect(find.text('Trapezoid'), findsOneWidget);
      },
    );
  });
}
