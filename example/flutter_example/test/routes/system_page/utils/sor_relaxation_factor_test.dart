import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_data_input.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/sor_relaxation_factor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../system_mock.dart';

void main() {
  group("Testing the 'RelaxationFactorInput' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.sor.asString(),
          child: const SingleChildScrollView(
            child: SystemDataInput(),
          ),
        ),
      );

      expect(find.byType(RelaxationFactorInput), findsOneWidget);
      expect(
        find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
        findsOneWidget,
      );
    });

    testWidgets(
      'Making sure that the widget does NOT show an input field '
      "when the system solving algorithm isn't SOR",
      (tester) async {
        await tester.pumpWidget(
          mockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString(),
            child: const SingleChildScrollView(
              child: SystemDataInput(),
            ),
          ),
        );

        expect(find.byType(RelaxationFactorInput), findsNothing);
      },
    );
  });

  group('Golden tests - RelaxationFactorInput', () {
    testWidgets('RelaxationFactorInput', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.sor.asString(),
          child: RelaxationFactorInput(
            textEditingController: TextEditingController(),
          ),
        ),
      );
      await expectLater(
        find.byType(RelaxationFactorInput),
        matchesGoldenFile('goldens/relaxation_factor_input.png'),
      );
    });
  });
}
