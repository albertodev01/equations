import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group('Making sure that sections logos can be rendered', () {
    testWidgets("Testing 'SectionTitle'", (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: SectionTitle(
            icon: Icon(Icons.ac_unit),
            pageTitle: 'Demo text',
          ),
        ),
      );

      expect(find.byType(SectionTitle), findsOneWidget);
      expect(find.text('Demo text'), findsOneWidget);
    });
  });

  group('Golden tests - SectionTitle', () {
    testWidgets('SectionTitle', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: SectionTitle(
            icon: Icon(Icons.ac_unit),
            pageTitle: 'Demo text',
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/section_title.png'),
      );
    });
  });
}
