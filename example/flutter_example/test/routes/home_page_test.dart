import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/home_page/home_contents.dart';
import 'package:equations_solver/routes/utils/app_logo.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'HomePage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: HomePage(),
      ));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(AppLogo), findsOneWidget);
      expect(find.byType(HomeContents), findsOneWidget);
      expect(find.byType(EquationScaffold), findsOneWidget);
    });
  });
}
