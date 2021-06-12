import 'package:equations_solver/routes/system_page.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'SystemPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: SystemPage(),
      ));

      expect(find.byType(SystemBody), findsOneWidget);
      expect(find.byType(SystemPage), findsOneWidget);
    });
  });
}
