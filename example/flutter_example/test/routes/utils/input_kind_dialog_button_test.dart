import 'package:equations_solver/routes/utils/input_kind_dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'InputKindDialogButton' class", () {
    test('InputKindMessage smoke test', () {
      expect(InputKindMessage.values.length, equals(2));
    });

    testWidgets('Smoke test', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: InputKindDialogButton(
            inputKindMessage: InputKindMessage.numbers,
          ),
        ),
      );

      expect(find.byType(InputKindDialogButton), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('Numeric input test', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: InputKindDialogButton(
            inputKindMessage: InputKindMessage.numbers,
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.byType(Card), findsNothing);

      expect(find.text('sqrt(x)'), findsNothing);
      expect(find.text('sin(x)'), findsNothing);
      expect(find.text('cos(x)'), findsNothing);
      expect(find.text('tan(x)'), findsNothing);
      expect(find.text('log(x)'), findsNothing);
      expect(find.text('acos(x)'), findsNothing);
      expect(find.text('asin(x)'), findsNothing);
      expect(find.text('atan(x)'), findsNothing);
      expect(find.text('csc(x)'), findsNothing);
      expect(find.text('sec(x)'), findsNothing);

      // Close the dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Equations input test', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: InputKindDialogButton(
            inputKindMessage: InputKindMessage.equations,
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(10));

      expect(find.text('sqrt(x)'), findsOneWidget);
      expect(find.text('sin(x)'), findsOneWidget);
      expect(find.text('cos(x)'), findsOneWidget);
      expect(find.text('tan(x)'), findsOneWidget);
      expect(find.text('log(x)'), findsOneWidget);
      expect(find.text('acos(x)'), findsOneWidget);
      expect(find.text('asin(x)'), findsOneWidget);
      expect(find.text('atan(x)'), findsOneWidget);
      expect(find.text('csc(x)'), findsOneWidget);
      expect(find.text('sec(x)'), findsOneWidget);

      // Close the dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('Golden tests - InputKindDialogButton', () {
    testWidgets('InputKindDialogButton - pressed', (tester) async {
      await tester.binding.setSurfaceSize(const Size(80, 80));

      await tester.pumpWidget(
        const MockWrapper(
          child: InputKindDialogButton(
            inputKindMessage: InputKindMessage.equations,
          ),
        ),
      );

      await tester.press(find.byType(IconButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(IconButton),
        matchesGoldenFile('goldens/input_kind_button_pressed.png'),
      );
    });

    testWidgets('InputKindDialogButton - numbers', (tester) async {
      await tester.binding.setSurfaceSize(const Size(700, 500));

      await tester.pumpWidget(
        const MockWrapper(
          child: InputKindDialogButton(
            inputKindMessage: InputKindMessage.numbers,
          ),
        ),
      );

      await tester.tap(find.byType(InputKindDialogButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AlertDialog),
        matchesGoldenFile('goldens/input_kind_button_number_dialog.png'),
      );
    });

    testWidgets('InputKindDialogButton - equations', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(
        const MockWrapper(
          child: InputKindDialogButton(
            inputKindMessage: InputKindMessage.equations,
          ),
        ),
      );

      await tester.tap(find.byType(InputKindDialogButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AlertDialog),
        matchesGoldenFile('goldens/input_kind_button_equations_dialog.png'),
      );
    });
  });
}
