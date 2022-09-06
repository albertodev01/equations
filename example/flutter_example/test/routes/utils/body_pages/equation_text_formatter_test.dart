import 'package:equations_solver/routes/utils/body_pages/equation_text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'EquationTextFormatter' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Scaffold(
            body: EquationTextFormatter(
              equation: 'x^2 - 5',
            ),
          ),
        ),
      );

      expect(find.byType(EquationTextFormatter), findsOneWidget);
      expect(find.byType(RichText), findsOneWidget);
    });
  });

  group('Golden tests - EquationTextFormatter', () {
    testWidgets('EquationTextFormatter', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 80));

      await tester.pumpWidget(
        const MockWrapper(
          child: SizedBox(
            width: 200,
            height: 100,
            child: EquationTextFormatter(
              equation: 'x^2 - 5',
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(EquationTextFormatter),
        matchesGoldenFile('goldens/equation_text_formatter.png'),
      );
    });
  });
}
