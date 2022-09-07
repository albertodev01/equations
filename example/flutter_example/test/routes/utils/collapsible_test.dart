import 'package:equations_solver/routes/utils/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'Collapsible' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Collapsible(
            primary: Text('Primary'),
            secondary: Text('Secondary'),
          ),
        ),
      );

      expect(find.byType(Collapsible), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('Making sure that expansion works', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Collapsible(
            primary: Text('Primary'),
            secondary: Text('Secondary'),
          ),
        ),
      );

      final transitionFinder = find.byType(SizeTransition);

      expect(find.byType(Collapsible), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(
        tester.widget<SizeTransition>(transitionFinder).sizeFactor.value,
        isZero,
      );

      // Expanding
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(
        tester.widget<SizeTransition>(transitionFinder).sizeFactor.value,
        equals(1),
      );
    });
  });

  group('Golden tests - Collapsible', () {
    testWidgets('Collapsible - collapsed', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 100));

      await tester.pumpWidget(
        const MockWrapper(
          child: Collapsible(
            primary: Text('Primary'),
            secondary: Text('Secondary'),
          ),
        ),
      );
      await expectLater(
        find.byType(Collapsible),
        matchesGoldenFile('goldens/collapsible_collapsed.png'),
      );
    });

    testWidgets('Collapsible - expanded', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Collapsible(
            primary: Text('Primary'),
            secondary: Text('Secondary'),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Collapsible),
        matchesGoldenFile('goldens/collapsible_expanded.png'),
      );
    });
  });
}
