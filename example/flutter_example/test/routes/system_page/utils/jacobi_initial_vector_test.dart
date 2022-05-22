import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/jacobi_initial_vector.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../system_mock.dart';

void main() {
  group("Testing the 'JacobiVectorInput' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.jacobi.asString(),
          child: JacobiVectorInput(
            controllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            vectorSize: 2,
          ),
        ),
      );

      expect(find.byType(JacobiVectorInput), findsOneWidget);
      expect(find.byType(VectorInput), findsOneWidget);
      expect(find.byType(SystemInputField), findsNWidgets(2));
    });

    testWidgets(
      'Making sure that nothing is rendered when the selected '
      'method is NOT Jacobi',
      (tester) async {
        await tester.pumpWidget(
          mockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString(),
            child: JacobiVectorInput(
              controllers: [
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
              ],
              vectorSize: 2,
            ),
          ),
        );

        expect(find.byType(JacobiVectorInput), findsOneWidget);
        expect(find.byType(VectorInput), findsNothing);
        expect(find.byType(SystemInputField), findsNothing);
      },
    );
  });
}
