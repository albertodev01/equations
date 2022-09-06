import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'NoDiscriminant' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: NoResults(),
        ),
      );

      expect(find.byType(NoResults), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.text('No solutions to display.'), findsOneWidget);
    });
  });

  group('Golden tests - NoResults', () {
    testWidgets('NoResults', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 80));

      await tester.pumpWidget(
        const MockWrapper(
          child: NoResults(),
        ),
      );
      await expectLater(
        find.byType(NoResults),
        matchesGoldenFile('goldens/no_results.png'),
      );
    });
  });
}
