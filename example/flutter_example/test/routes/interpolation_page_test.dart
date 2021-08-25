import 'package:equations_solver/routes/interpolation_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'InterpolationPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: InterpolationPage(),
      ));

      expect(find.byType(InterpolationPage), findsOneWidget);
    });
  });
}
