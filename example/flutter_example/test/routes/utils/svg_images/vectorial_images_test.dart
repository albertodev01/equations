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
        await tester.pumpWidget(
          const MockWrapper(
            child: ArrowUpSvg(),
          ),
        );

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

    testGoldens('ToolsComplexNumbers', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const OtherComplexNumbers());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'tools_complex_numbers');
    });

    testGoldens('ToolsMatrix', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const OtherMatrix());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'tools_matrix');
    });

    testGoldens('SquareRoot', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const SquareRoot());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'square_root');
    });

    testGoldens('SquareMatrix', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const SquareMatrix());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'square_matrix');
    });

    testGoldens('HalfRightAngle', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const HalfRightAngle());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'half_right_angle');
    });

    testGoldens('PlotIcon', (tester) async {
      final builder = GoldenBuilder.column()..addScenario('', const PlotIcon());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'plot_icon');
    });

    testGoldens('EquationSolution', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const EquationSolution());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'equation_solution');
    });

    testGoldens('Atoms', (tester) async {
      final builder = GoldenBuilder.column()..addScenario('', const Atoms());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'atoms');
    });

    testGoldens('UrlError', (tester) async {
      final builder = GoldenBuilder.column()..addScenario('', const UrlError());

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(100, 100),
      );
      await screenMatchesGolden(tester, 'url_error');
    });
  });
}
