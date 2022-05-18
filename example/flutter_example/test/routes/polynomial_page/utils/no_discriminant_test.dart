import 'package:equations_solver/routes/polynomial_page/utils/no_discriminant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'NoDiscriminant' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(child: NoDiscriminant()));

      expect(find.byType(NoDiscriminant), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.text('No discriminant.'), findsOneWidget);
    });
  });

  group('Golden tests - NoDiscriminant', () {
    testWidgets('NoDiscriminant', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: NoDiscriminant(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/no_discriminant.png'),
      );
    });
  });
}
