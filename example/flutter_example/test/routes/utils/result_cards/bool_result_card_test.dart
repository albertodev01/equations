import 'dart:ui';

import 'package:equations_solver/routes/utils/result_cards/bool_result_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'BoolResultCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: BoolResultCard(
            leading: 'Test: ',
            value: true,
          ),
        ),
      );

      expect(find.byType(BoolResultCard), findsOneWidget);
      expect(find.text('Test: Yes'), findsOneWidget);
    });
  });

  group('Golden tests - BoolResultCard', () {
    testWidgets('BoolResultCard - true', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: BoolResultCard(
            leading: 'Test: ',
            value: true,
          ),
        ),
      );
      await expectLater(
        find.byType(BoolResultCard),
        matchesGoldenFile('goldens/bool_result_card_true.png'),
      );
    });

    testWidgets('BoolResultCard - false', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: BoolResultCard(
            leading: 'Test: ',
            value: false,
          ),
        ),
      );
      await expectLater(
        find.byType(BoolResultCard),
        matchesGoldenFile('goldens/bool_result_card_false.png'),
      );
    });
  });
}
