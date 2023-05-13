import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
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
        MockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.jacobi.asString,
          child: const JacobiVectorInput(),
        ),
      );

      expect(find.byType(JacobiVectorInput), findsOneWidget);
      expect(find.byType(VectorInput), findsOneWidget);
      expect(find.byType(SystemInputField), findsOneWidget);
    });

    testWidgets(
      'Making sure that nothing is rendered when the selected '
      'method is NOT Jacobi',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString,
            child: const JacobiVectorInput(),
          ),
        );

        expect(find.byType(JacobiVectorInput), findsOneWidget);
        expect(find.byType(VectorInput), findsNothing);
        expect(find.byType(SystemInputField), findsNothing);
      },
    );
  });

  group('Golden tests - JacobiVectorInput', () {
    testWidgets('JacobiVectorInput - 1', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 170));

      await tester.pumpWidget(
        MockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.jacobi.asString,
          child: const JacobiVectorInput(),
        ),
      );
      await expectLater(
        find.byType(JacobiVectorInput),
        matchesGoldenFile('goldens/jacobi_vector_input_1.png'),
      );
    });

    testWidgets('JacobiVectorInput - 2', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 220));

      await tester.pumpWidget(
        MockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.jacobi.asString,
          child: const JacobiVectorInput(),
        ),
      );

      tester
          .widget<InheritedNumberSwitcher>(find.byType(InheritedNumberSwitcher))
          .numberSwitcherState
          .increase();

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(JacobiVectorInput),
        matchesGoldenFile('goldens/jacobi_vector_input_2.png'),
      );
    });

    testWidgets('JacobiVectorInput - 3', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 270));

      await tester.pumpWidget(
        MockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.jacobi.asString,
          child: const JacobiVectorInput(),
        ),
      );

      tester
          .widget<InheritedNumberSwitcher>(find.byType(InheritedNumberSwitcher))
          .numberSwitcherState
        ..increase()
        ..increase();

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(JacobiVectorInput),
        matchesGoldenFile('goldens/jacobi_vector_input_3.png'),
      );
    });

    testWidgets('JacobiVectorInput - 4', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 340));

      await tester.pumpWidget(
        MockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.jacobi.asString,
          child: const JacobiVectorInput(),
        ),
      );

      tester
          .widget<InheritedNumberSwitcher>(find.byType(InheritedNumberSwitcher))
          .numberSwitcherState
        ..increase()
        ..increase()
        ..increase();

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(JacobiVectorInput),
        matchesGoldenFile('goldens/jacobi_vector_input_4.png'),
      );
    });
  });
}
