import 'package:equations_solver/routes/utils/result_cards/message_card.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'MessageCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: MessageCard(
            message: 'Test',
          ),
        ),
      );

      expect(find.byType(MessageCard), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('Golden tests - MessageCard', () {
    testWidgets('MessageCard', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(
              left: 6,
              bottom: 6,
            ),
            child: MessageCard(
              message: 'Test',
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MessageCard),
        matchesGoldenFile('goldens/message_card.png'),
      );
    });

    testWidgets('MessageCard - long text', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(
              left: 6,
              bottom: 6,
            ),
            child: MessageCard(
              message:
                  'Test with a very very long text that goes to a new line',
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MessageCard),
        matchesGoldenFile('goldens/message_card_long_text.png'),
      );
    });
  });
}
