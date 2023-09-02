import 'package:equations_solver/routes/utils/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'AppLogo' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(child: AppLogo()));

      expect(find.byType(AppLogo), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });

  group('Golden tests - AppLogo', () {
    testWidgets('AppLogo', (tester) async {
      await tester.binding.setSurfaceSize(const Size(90, 90));

      await tester.pumpWidget(
        const MockWrapper(
          child: AppLogo(),
        ),
      );
      await expectLater(
        find.byType(AppLogo),
        matchesGoldenFile('goldens/app_logo.png'),
      );
    });
  });
}
