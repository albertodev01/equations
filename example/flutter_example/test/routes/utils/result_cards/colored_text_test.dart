import 'package:equations_solver/routes/utils/result_cards/colored_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'ColoredText' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ColoredText(
            leading: 'Leading: ',
            value: 'value',
          ),
        ),
      );

      expect(find.byType(ColoredText), findsOneWidget);
      expect(find.text('Leading: value'), findsOneWidget);
    });
  });

  group('Golden tests - ColoredText', () {
    testWidgets('ColoredText', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 60));

      await tester.pumpWidget(
        const MockWrapper(
          child: ColoredText(
            leading: 'Leading: ',
            value: 'value',
          ),
        ),
      );
      await expectLater(
        find.byType(ColoredText),
        matchesGoldenFile('goldens/colored_text.png'),
      );
    });
  });
}
