import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../system_mock.dart';

void main() {
  group("Testing the 'SystemDropdownSelection' widget", () {
    test("Testing the 'SystemDropdownItemsExt' extension method", () {
      expect(SystemDropdownItems.lu.asString, equals('LU'));
      expect(SystemDropdownItems.cholesky.asString, equals('Cholesky'));
      expect(SystemDropdownItems.sor.asString, equals('SOR'));
      expect(SystemDropdownItems.jacobi.asString, equals('Jacobi'));
    });

    test("Testing the 'StringExt' extension method", () {
      expect(
        'lu'.toSystemDropdownItems(),
        equals(SystemDropdownItems.lu),
      );
      expect(
        'cholesky'.toSystemDropdownItems(),
        equals(SystemDropdownItems.cholesky),
      );
      expect(
        'sor'.toSystemDropdownItems(),
        equals(SystemDropdownItems.sor),
      );
      expect(
        'jacobi'.toSystemDropdownItems(),
        equals(SystemDropdownItems.jacobi),
      );
      expect(''.toSystemDropdownItems, throwsArgumentError);
    });

    testWidgets(
      'Making sure that the widget shows no dropdown when row '
      'reduction type is selected',
      (tester) async {
        await tester.pumpWidget(
          const MockSystemWidget(
            child: SystemDropdownSelection(),
          ),
        );

        expect(find.byType(SystemDropdownSelection), findsOneWidget);
        expect(
          find.byKey(const Key('System-Dropdown-Button-Selection')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that the widget shows the dropdown when the '
      'factorization type is selected',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString,
            child: const SystemDropdownSelection(),
          ),
        );

        expect(find.byType(SystemDropdownSelection), findsOneWidget);
        expect(
          find.byKey(const Key('System-Dropdown-Button-Selection')),
          findsOneWidget,
        );
        expect(find.text('LU'), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the widget shows the dropdown when the '
      'iterative type is selected',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.iterative,
            dropdownValue: SystemDropdownItems.sor.asString,
            child: const SystemDropdownSelection(),
          ),
        );

        expect(find.byType(SystemDropdownSelection), findsOneWidget);
        expect(
          find.byKey(const Key('System-Dropdown-Button-Selection')),
          findsOneWidget,
        );
        expect(find.text('SOR'), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that dropdown values can be changed',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            systemType: SystemType.factorization,
            dropdownValue: SystemDropdownItems.lu.asString,
            child: const SystemDropdownSelection(),
          ),
        );

        await tester.tap(find.text('LU'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cholesky').last);
        await tester.pumpAndSettle();
      },
    );
  });

  group('Golden tests - SystemDropdownSelection', () {
    testWidgets('SystemDropdownSelection - gauss', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 150));

      await tester.pumpWidget(
        MockWrapper(
          child: InheritedSystem(
            systemState: SystemState(SystemType.rowReduction),
            child: InheritedDropdownValue(
              dropdownValue: ValueNotifier<String>(''),
              child: const SystemDropdownSelection(),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemDropdownSelection),
        matchesGoldenFile('goldens/dropdown_input_gauss.png'),
      );
    });

    testWidgets('SystemDropdownSelection - lu', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedSystem(
            systemState: SystemState(SystemType.factorization),
            child: InheritedDropdownValue(
              dropdownValue: ValueNotifier<String>(
                SystemDropdownItems.lu.asString,
              ),
              child: const SystemDropdownSelection(),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemDropdownSelection),
        matchesGoldenFile('goldens/dropdown_input_lu.png'),
      );
    });

    testWidgets('SystemDropdownSelection - cholesky', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedSystem(
            systemState: SystemState(SystemType.factorization),
            child: InheritedDropdownValue(
              dropdownValue: ValueNotifier<String>(
                SystemDropdownItems.cholesky.asString,
              ),
              child: const SystemDropdownSelection(),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemDropdownSelection),
        matchesGoldenFile('goldens/dropdown_input_cholesky.png'),
      );
    });

    testWidgets('SystemDropdownSelection - jacobi', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedSystem(
            systemState: SystemState(SystemType.iterative),
            child: InheritedDropdownValue(
              dropdownValue: ValueNotifier<String>(
                SystemDropdownItems.jacobi.asString,
              ),
              child: const SystemDropdownSelection(),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemDropdownSelection),
        matchesGoldenFile('goldens/dropdown_input_jacobi.png'),
      );
    });

    testWidgets('SystemDropdownSelection - sor', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedSystem(
            systemState: SystemState(SystemType.iterative),
            child: InheritedDropdownValue(
              dropdownValue: ValueNotifier<String>(
                SystemDropdownItems.sor.asString,
              ),
              child: const SystemDropdownSelection(),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemDropdownSelection),
        matchesGoldenFile('goldens/dropdown_input_sor.png'),
      );
    });
  });
}
