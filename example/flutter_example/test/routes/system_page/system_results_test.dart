import 'package:equations_solver/routes/system_page/system_results.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter_test/flutter_test.dart';

import 'system_mock.dart';

void main() {
  group("Testing the 'PolynomialResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        mockSystemWidget(
          child: const SystemResults(),
        ),
      );

      expect(find.byType(SystemResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
      expect(find.byType(EquationSolution), findsOneWidget);
    });
  });
}
