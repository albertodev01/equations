import 'package:equations_solver/routes/system_page/utils/double_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'DoubleResultCard' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: DoubleResultCard(
          value: 0.5,
        ),
      ));

      expect(find.byType(DoubleResultCard), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('x = 0.5'), findsOneWidget);
      expect(find.text('Fraction: 1/2'), findsOneWidget);
    });
  });
}
