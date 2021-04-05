import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equations_solver/main.dart' as app_main;

void main() {
  group('Testing the entrypoint of the app', () {
    testWidgets(
        "Making sure that the root widget contains a 'MaterialApp' and"
        ' it is correctly initialized', (tester) async {
      await tester.pumpWidget(const app_main.EquationsApp());

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
