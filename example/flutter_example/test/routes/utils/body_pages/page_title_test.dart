import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PageTitle' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: Scaffold(
            body: PageTitle(
              pageLogo: SvgPicture.asset(
                'assets/function.svg',
                width: 50,
                height: 50,
              ),
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
      await tester.pumpWidget(
        MockWrapper(
          child: SizedBox(
            width: 300,
            height: 300,
            child: PageTitle(
              pageLogo: SvgPicture.asset(
                'assets/function.svg',
                width: 50,
                height: 60,
              ),
              pageTitle: 'Demo title',
            ),
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
