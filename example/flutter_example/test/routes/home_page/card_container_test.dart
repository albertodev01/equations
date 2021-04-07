import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'HomePage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: CardContainer(
          title: 'Title',
          image: const SizedBox(),
          onTap: () {},
        ),
      ));

      expect(find.byType(CardContainer), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Making sure that the widget is tappable', (tester) async {
      var counter = 0;

      await tester.pumpWidget(MockWrapper(
        child: CardContainer(
          title: 'Title',
          image: const SizedBox(),
          onTap: () => counter++,
        ),
      ));

      final card = find.byType(CardContainer);

      await tester.tap(card);
      await tester.tap(card);

      expect(counter, equals(2));
    });

    testGoldens('CardContainer', (tester) async {
      final widget = CardContainer(
        title: 'Title',
        image: const SizedBox(),
        onTap: () {},
      );

      final builder = GoldenBuilder.column()
        ..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(800, 800),
      );
      await screenMatchesGolden(tester, 'card_container');
    });
  });
}