import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_results.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'system_mock.dart';

void main() {
  group("Testing the 'PolynomialResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockSystemWidget(
          child: SystemResults(),
        ),
      );

      expect(find.byType(SystemResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
      expect(find.byType(EquationSolution), findsOneWidget);
    });

    testWidgets(
      'Making sure that, when there are no solutions, no result cards appear',
      (tester) async {
        await tester.pumpWidget(
          const MockSystemWidget(
            child: SystemResults(),
          ),
        );

        expect(find.byType(NoResults), findsOneWidget);
        expect(find.byType(RealResultCard), findsNothing);
      },
    );

    testWidgets(
      'Making sure that, when there are solutions, result cards appear',
      (tester) async {
        await tester.pumpWidget(
          MockSystemWidget(
            child: InheritedSystem(
              systemState: SystemState(SystemType.rowReduction)
                ..rowReductionSolver(
                  flatMatrix: ['-2', '3', '1', '5'],
                  knownValues: ['3', '2'],
                  size: 2,
                ),
              child: const SystemResults(),
            ),
          ),
        );

        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(2));
      },
    );
  });

  group('Golden tests - SystemResults', () {
    testWidgets('SystemResults - no results', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 250));

      await tester.pumpWidget(
        const MockSystemWidget(
          child: SystemResults(),
        ),
      );
      await expectLater(
        find.byType(SystemResults),
        matchesGoldenFile('goldens/system_results_nothing.png'),
      );
    });

    testWidgets('SystemResults - no results', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 450));

      await tester.pumpWidget(
        MockSystemWidget(
          child: InheritedSystem(
            systemState: SystemState(SystemType.rowReduction)
              ..rowReductionSolver(
                flatMatrix: ['-2', '3', '1', '5'],
                knownValues: ['3', '2'],
                size: 2,
              ),
            child: const SystemResults(),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemResults),
        matchesGoldenFile('goldens/system_results_cards.png'),
      );
    });
  });
}
