import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_data_input.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'system_mock.dart';

void main() {
  group("Testing the 'SystemDataInput' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          child: const SystemDataInput(),
        ),
      );

      expect(find.byType(SystemDataInput), findsOneWidget);
      expect(find.byType(SizePicker), findsOneWidget);
      expect(find.byType(MatrixInput), findsOneWidget);
      expect(find.byType(VectorInput), findsOneWidget);
      expect(find.byType(SystemDropdownSelection), findsOneWidget);

      expect(find.byKey(const Key('System-button-solve')), findsOneWidget);
      expect(find.byKey(const Key('System-button-clean')), findsOneWidget);
    });

    testWidgets(
      'Making sure that row reduction methods do not show SOR or jacobi inputs',
      (tester) async {
        await tester.pumpWidget(
          mockSystemWidget(
            child: const SystemDataInput(),
          ),
        );

        expect(find.byType(SystemDataInput), findsOneWidget);
        expect(
          find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
          findsNothing,
        );
        expect(
          find.byKey(
            const Key('Jacobi-Vector-Input-Column'),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that LU does not show SOR or jacobi inputs',
      (tester) async {
        await tester.pumpWidget(
          mockSystemWidget(
            dropdownValue: SystemDropdownItems.lu.asString(),
            systemType: SystemType.factorization,
            child: const SystemDataInput(),
          ),
        );

        expect(find.byType(SystemDataInput), findsOneWidget);
        expect(
          find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
          findsNothing,
        );
        expect(
          find.byKey(
            const Key('Jacobi-Vector-Input-Column'),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that Cholesky does not show SOR or jacobi inputs',
      (tester) async {
        await tester.pumpWidget(
          mockSystemWidget(
            dropdownValue: SystemDropdownItems.cholesky.asString(),
            systemType: SystemType.factorization,
            child: const SystemDataInput(),
          ),
        );

        expect(find.byType(SystemDataInput), findsOneWidget);
        expect(
          find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
          findsNothing,
        );
        expect(
          find.byKey(
            const Key('Jacobi-Vector-Input-Column'),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that SOR only shows the relaxation factor input',
      (tester) async {
        await tester.pumpWidget(
          mockSystemWidget(
            dropdownValue: SystemDropdownItems.sor.asString(),
            systemType: SystemType.iterative,
            child: const SingleChildScrollView(
              child: SystemDataInput(),
            ),
          ),
        );

        expect(find.byType(SystemDataInput), findsOneWidget);
        expect(
          find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const Key('Jacobi-Vector-Input-Column'),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that Jacobi only shows the initial vector input',
      (tester) async {
        await tester.pumpWidget(
          mockSystemWidget(
            dropdownValue: SystemDropdownItems.jacobi.asString(),
            systemType: SystemType.iterative,
            child: const SingleChildScrollView(
              child: SystemDataInput(),
            ),
          ),
        );

        expect(find.byType(SystemDataInput), findsOneWidget);
        expect(
          find.byKey(const Key('SystemSolver-Iterative-RelaxationFactor')),
          findsNothing,
        );
        expect(
          find.byKey(
            const Key('Jacobi-Vector-Input-Column'),
          ),
          findsOneWidget,
        );
      },
    );
  });

  group('Golden tests - SystemDataInput', () {
    testWidgets('SystemDataInput - Row reduction', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          child: const SystemDataInput(),
        ),
      );
      await expectLater(
        find.byType(SystemDataInput),
        matchesGoldenFile('goldens/system_data_input_row_reduction.png'),
      );
    });

    testWidgets('SystemDataInput - LU', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          systemType: SystemType.factorization,
          dropdownValue: SystemDropdownItems.lu.asString(),
          child: const SystemDataInput(),
        ),
      );
      await expectLater(
        find.byType(SystemDataInput),
        matchesGoldenFile('goldens/system_data_input_lu.png'),
      );
    });

    testWidgets('SystemDataInput - Cholesky', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          systemType: SystemType.factorization,
          dropdownValue: SystemDropdownItems.cholesky.asString(),
          child: const SystemDataInput(),
        ),
      );
      await expectLater(
        find.byType(SystemDataInput),
        matchesGoldenFile('goldens/system_data_input_cholesky.png'),
      );
    });

    testWidgets('SystemDataInput - SOR', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.sor.asString(),
          child: const SingleChildScrollView(
            child: SystemDataInput(),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemDataInput),
        matchesGoldenFile('goldens/system_data_input_sor.png'),
      );
    });

    testWidgets('SystemDataInput - Jacobi', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          systemType: SystemType.iterative,
          dropdownValue: SystemDropdownItems.jacobi.asString(),
          child: const SingleChildScrollView(
            child: SystemDataInput(),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemDataInput),
        matchesGoldenFile('goldens/system_data_input_jacobi.png'),
      );
    });
  });
}
