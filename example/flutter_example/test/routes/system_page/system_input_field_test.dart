import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'SystemBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: SystemInputField(
            controller: TextEditingController(),
          ),
        ),
      );

      expect(find.byType(SystemInputField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });

  group('Golden tests - SystemInputField', () {
    testWidgets('SystemInputField - without placeholder', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: SystemInputField(
            controller: TextEditingController(),
          ),
        ),
      );
      await expectLater(
        find.byType(SystemInputField),
        matchesGoldenFile('goldens/system_input_field_noplaceholder.png'),
      );
    });

    testWidgets('SystemInputField - with placeholder', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: SystemInputField(
            controller: TextEditingController(),
            placeholder: 'x',
          ),
        ),
      );
      await expectLater(
        find.byType(SystemInputField),
        matchesGoldenFile('goldens/system_input_field_placeholder.png'),
      );
    });
  });
}
