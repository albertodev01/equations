import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'NonlinearPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: NonlinearPage(),
      ));

      expect(find.byType(NonlinearBody), findsOneWidget);
      expect(find.byType(NonlinearPage), findsOneWidget);
    });
  });
}
