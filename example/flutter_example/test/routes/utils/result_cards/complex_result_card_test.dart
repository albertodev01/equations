import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/collapsible.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'ComplexResultCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ComplexResultCard(
            value: Complex(5, -3),
          ),
        ),
      );

      expect(find.byType(ComplexResultCard), findsOneWidget);
      expect(find.byType(Collapsible), findsOneWidget);
      expect(find.text('5 - 3i'), findsOneWidget);
    });

    testWidgets('Making sure that the leading string appears', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ComplexResultCard(
            leading: 'Text: ',
            value: Complex(5, -3),
          ),
        ),
      );

      expect(find.text('Text: 5 - 3i'), findsOneWidget);
    });

    testWidgets('Making sure that the trailing widget appears', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ComplexResultCard(
            trailing: Text('Text'),
            value: Complex(5, -3),
          ),
        ),
      );

      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets(
      "Making sure that when the value is 'NaN', an error message "
      'actually appears',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: ComplexResultCard(
              value: Complex(5, double.nan),
            ),
          ),
        );

        expect(find.byType(ComplexResultCard), findsOneWidget);
        expect(find.text('Not computed'), findsOneWidget);
      },
    );
  });

  group('Golden tests - ComplexResultCard', () {
    testWidgets('ComplexResultCard', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: ComplexResultCard(
              value: Complex(pi, e),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_card.png'),
      );
    });

    testWidgets('ComplexResultCard - leading value', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: ComplexResultCard(
              value: Complex(pi, e),
              leading: 'z = ',
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_card_leading.png'),
      );
    });

    testWidgets('ComplexResultCard - leading and trailing', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 150));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: ComplexResultCard(
              value: Complex(pi, e),
              leading: 'z = ',
              trailing: Text(':)'),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_card_leading_trailing.png'),
      );
    });

    testWidgets('ComplexResultCard - expanded', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 300));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: ComplexResultCard(
              value: Complex(pi, e),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_card_expanded.png'),
      );
    });

    testWidgets('ComplexResultCard - expanded with NaN', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 300));

      await tester.pumpWidget(
        const MockWrapper(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: ComplexResultCard(
              value: Complex(double.negativeInfinity, double.nan),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_card_expanded_with_nan.png'),
      );
    });
  });
}
