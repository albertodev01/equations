import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../mock_wrapper.dart';

void main() {
  group('Making sure that sections logos can be rendered', () {
    testWidgets("Making sure that 'PolynomialLogo' can be rendered",
        (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: PolynomialLogo(),
      ));

      expect(find.byType(PolynomialLogo), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testGoldens('PolynomialLogo', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const PolynomialLogo());

      await tester.pumpWidgetBuilder(builder.build(),
          wrapper: (child) => MockWrapper(child: child),
          surfaceSize: const Size(100, 100));
      await screenMatchesGolden(tester, 'section_logo_polynomial');
    });

    testWidgets("Making sure that 'NonlinearLogo' can be rendered",
        (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: NonlinearLogo(),
      ));

      expect(find.byType(NonlinearLogo), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testGoldens('NonlinearLogo', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const NonlinearLogo());

      await tester.pumpWidgetBuilder(builder.build(),
          wrapper: (child) => MockWrapper(child: child),
          surfaceSize: const Size(100, 100));
      await screenMatchesGolden(tester, 'section_logo_nonlinear');
    });

    testWidgets("Making sure that 'SystemsLogo' can be rendered",
        (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: SystemsLogo(),
      ));

      expect(find.byType(SystemsLogo), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testGoldens('SystemsLogo', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const SystemsLogo());

      await tester.pumpWidgetBuilder(builder.build(),
          wrapper: (child) => MockWrapper(child: child),
          surfaceSize: const Size(100, 100));
      await screenMatchesGolden(tester, 'section_logo_systems');
    });

    testWidgets("Making sure that 'IntegralLogo' can be rendered",
        (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: IntegralLogo(),
      ));

      expect(find.byType(IntegralLogo), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testGoldens('IntegralLogo', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('', const IntegralLogo());

      await tester.pumpWidgetBuilder(builder.build(),
          wrapper: (child) => MockWrapper(child: child),
          surfaceSize: const Size(100, 100));
      await screenMatchesGolden(tester, 'section_logo_integral');
    });
  });
}
