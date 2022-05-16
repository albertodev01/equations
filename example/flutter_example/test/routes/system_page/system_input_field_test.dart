import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
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

    testGoldens('SystemInputField', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Without placeholder',
          SystemInputField(
            controller: TextEditingController(),
          ),
        )
        ..addScenario(
          'With placeholder',
          SystemInputField(
            controller: TextEditingController(),
            placeholder: 'Placeholder',
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(400, 500),
      );
      await screenMatchesGolden(tester, 'system_input_field');
    });
  });
}
