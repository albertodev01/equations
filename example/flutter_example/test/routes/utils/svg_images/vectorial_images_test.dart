import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group('Making sure that sections logos can be rendered', () {
    testWidgets(
      "Making sure that 'ArrowUpSvg' can be rendered",
      (tester) async {
        await tester.pumpWidget(const MockWrapper(
          child: ArrowUpSvg(),
        ));

        expect(find.byType(ArrowUpSvg), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testGoldens('ArrowUpSvg', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const ArrowUpSvg());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'vectorial_arrow_up');
    });

    testGoldens('ToolsSquareX', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const ToolsSquareX());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'tools_square_x');
    });

    testGoldens('ToolsMatrix', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const ToolsMatrix());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'tools_matrix');
    });
  });
}
