import 'package:equations_solver/routes/utils/equation_scaffold/scaffold_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'RailNavigationWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ScaffoldContents(
            body: SizedBox.shrink(
              key: Key('test'),
            ),
          ),
        ),
      );

      expect(find.byType(ScaffoldContents), findsOneWidget);
      expect(find.byKey(const Key('test')), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });

  group('Golden tests - ScaffoldContents', () {
    testWidgets('ScaffoldContents', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ScaffoldContents(
            body: Center(
              child: Text('scaffold contents'),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(ScaffoldContents),
        matchesGoldenFile('goldens/scaffold_contents.png'),
      );
    });
  });
}
