import 'package:equations_solver/routes/error_page.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'ErrorPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ErrorPage(),
        ),
      );

      expect(find.byType(SliverFillRemaining), findsOneWidget);
      expect(find.byType(UrlError), findsOneWidget);
      expect(find.byType(ErrorPage), findsOneWidget);
      expect(find.byType(EquationScaffold), findsOneWidget);
    });
  });

  group('Golden tests - ErrorPage', () {
    testWidgets('ErrorPage', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ErrorPage(),
        ),
      );

      await expectLater(
        find.byType(ErrorPage),
        matchesGoldenFile('goldens/error_page.png'),
      );
    });
  });
}
