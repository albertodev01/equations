import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'HomePage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: CardContainer(
            title: 'Title',
            image: const SizedBox(),
            // ignore: no-empty-block
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(CardContainer), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Making sure that the widget is tappable', (tester) async {
      var counter = 0;

      await tester.pumpWidget(
        MockWrapper(
          child: CardContainer(
            title: 'Title',
            image: const SizedBox(),
            onTap: () => counter++,
          ),
        ),
      );

      final card = find.byType(CardContainer);

      await tester.tap(card);
      await tester.tap(card);

      expect(counter, equals(2));
    });
  });

  group('Golden tests', () {
    testWidgets('Golden test - CardContainer', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: CardContainer(
            title: 'Title',
            image: const SizedBox(),
            // ignore: no-empty-block
            onTap: () {},
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/cardcontainer_no_image.png'),
      );
    });

    testWidgets('Golden test - CardContainer', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: CardContainer(
            title: 'Title',
            image: const Icon(Icons.ac_unit),
            // ignore: no-empty-block
            onTap: () {},
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/cardcontainer_with_image.png'),
      );
    });
  });
}
