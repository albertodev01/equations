import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PageTitle' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Scaffold(
            body: PageTitle(
              pageLogo: PolynomialLogo(),
              pageTitle: 'Demo title',
            ),
          ),
        ),
      );

      expect(find.byType(PageTitle), findsOneWidget);
      expect(find.text('Demo title'), findsOneWidget);
    });
  });

  group('Golden tests - PageTitle', () {
    testWidgets('PageTitle', (tester) async {
      await tester.binding.setSurfaceSize(const Size(340, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: PageTitle(
            pageLogo: PolynomialLogo(),
            pageTitle: 'Demo title',
          ),
        ),
      );
      await expectLater(
        find.byType(PageTitle),
        matchesGoldenFile('goldens/page_title.png'),
      );
    });
  });
}
