import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/other_page/complex_numbers_body.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'OtherPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: OtherPage(),
        ),
      );

      expect(find.byType(EquationScaffold), findsOneWidget);
      expect(find.byType(MatrixOtherBody), findsOneWidget);
      expect(find.byType(ComplexNumberOtherBody), findsNothing);
    });
  });

  group('Golden tests - IntegralBody', () {
    Future<void> analyzeMatrix(WidgetTester tester) async {
      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pumpAndSettle();

      // Analyzing the matrix
      await tester.tap(find.byKey(const Key('MatrixAnalyze-button-analyze')));
      await tester.pumpAndSettle();
    }

    Future<void> analyzeComplexNumber(WidgetTester tester) async {
      tester
          .widget<InheritedNavigation>(
            find.byType(InheritedNavigation),
          )
          .navigationIndex
          .value = 1;

      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(
          const Key('ComplexNumberInput-TextFormField-RealPart'),
        ),
        '1',
      );
      await tester.enterText(
        find.byKey(
          const Key('ComplexNumberInput-TextFormField-ImaginaryPart'),
        ),
        '2',
      );
      await tester.pumpAndSettle();

      // Analyzing the matrix
      await tester.tap(find.byKey(const Key('ComplexAnalyze-button-analyze')));
      await tester.pumpAndSettle();
    }

    testWidgets('OtherPage - matrix - small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1500));

      await tester.pumpWidget(
        const MockWrapper(
          child: OtherPage(),
        ),
      );

      await analyzeMatrix(tester);

      await expectLater(
        find.byType(MatrixOtherBody),
        matchesGoldenFile('goldens/other_body_matrix_small_screen_part1.png'),
      );
    });

    testWidgets('OtherPage - matrix - small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 900));

      await tester.pumpWidget(
        const MockWrapper(
          child: OtherPage(),
        ),
      );

      await analyzeMatrix(tester);

      await tester.dragUntilVisible(
        find.byKey(const Key('MatrixAnalyzerResults-cofactor-matrix')),
        find.byType(ListView),
        const Offset(0, 500),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MatrixOtherBody),
        matchesGoldenFile('goldens/other_body_matrix_small_screen_part2.png'),
      );
    });

    testWidgets('OtherPage - matrix - large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1500, 1150));

      await tester.pumpWidget(
        const MockWrapper(
          child: OtherPage(),
        ),
      );

      await analyzeMatrix(tester);

      await expectLater(
        find.byType(MatrixOtherBody),
        matchesGoldenFile('goldens/other_body_matrix_large_screen.png'),
      );
    });

    testWidgets('OtherPage - complex - small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1450));

      await tester.pumpWidget(
        const MockWrapper(
          child: OtherPage(),
        ),
      );

      await analyzeComplexNumber(tester);

      await expectLater(
        find.byType(ComplexNumberOtherBody),
        matchesGoldenFile('goldens/other_body_complex_small_screen.png'),
      );
    });

    testWidgets('OtherPage - complex - large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1100, 1000));

      await tester.pumpWidget(
        const MockWrapper(
          child: OtherPage(),
        ),
      );

      await analyzeComplexNumber(tester);

      await expectLater(
        find.byType(ComplexNumberOtherBody),
        matchesGoldenFile('goldens/other_body_complex_large_screen.png'),
      );
    });
  });
}
