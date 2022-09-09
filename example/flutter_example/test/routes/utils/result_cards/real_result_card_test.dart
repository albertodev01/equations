import 'dart:math';

import 'package:equations_solver/routes/utils/collapsible.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'RealResultCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: RealResultCard(
            value: pi,
          ),
        ),
      );

      expect(find.byType(RealResultCard), findsOneWidget);
      expect(find.byType(Collapsible), findsOneWidget);
      expect(find.text('3.14159'), findsOneWidget);
    });

    testWidgets('Making sure that the leading string appears', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: RealResultCard(
            leading: 'text ',
            value: pi,
          ),
        ),
      );

      expect(find.text('text 3.14159'), findsOneWidget);
    });

    testWidgets(
      "Making sure that when the value is 'NaN', an error message "
      'actually appears',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: RealResultCard(
              value: double.nan,
            ),
          ),
        );

        expect(find.byType(RealResultCard), findsOneWidget);
        expect(find.text('Not computed'), findsOneWidget);
      },
    );
  });

  group('Golden tests - RealResultCard', () {
    testWidgets('RealResultCard', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: RealResultCard(
              value: pi,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(RealResultCard),
        matchesGoldenFile('goldens/real_result_card.png'),
      );
    });

    testWidgets('RealResultCard - leading value', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: RealResultCard(
              value: pi,
              leading: 'pi: ',
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(RealResultCard),
        matchesGoldenFile('goldens/real_result_card_leading.png'),
      );
    });

    testWidgets('RealResultCard - expanded', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 250));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: RealResultCard(
              value: pi,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(RealResultCard),
        matchesGoldenFile('goldens/real_result_card_expanded.png'),
      );
    });

    testWidgets('RealResultCard - expanded with NaN', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 250));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: RealResultCard(
              value: double.nan,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(RealResultCard),
        matchesGoldenFile('goldens/real_result_card_expanded_with_nan.png'),
      );
    });
  });
}
