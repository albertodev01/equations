import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group('Making sure that sections logos can be rendered', () {
    testWidgets(
      "Making sure that 'PolynomialLogo' can be rendered",
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: PolynomialLogo(),
          ),
        );

        expect(find.byType(PolynomialLogo), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that 'NonlinearLogo' can be rendered",
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: NonlinearLogo(),
          ),
        );

        expect(find.byType(NonlinearLogo), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that 'SystemsLogo' can be rendered",
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: SystemsLogo(),
          ),
        );

        expect(find.byType(SystemsLogo), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that 'IntegralLogo' can be rendered",
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: IntegralLogo(),
          ),
        );

        expect(find.byType(IntegralLogo), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testWidgets("Making sure that 'OtherLogo' can be rendered", (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: OtherLogo(),
        ),
      );

      expect(find.byType(OtherLogo), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });

  group('Golden tests - PolynomialLogo', () {
    testWidgets('PolynomialLogo', (tester) async {
      await tester.binding.setSurfaceSize(const Size.square(210));

      await tester.pumpWidget(
        const MockWrapper(
          child: PolynomialLogo(
            size: 200,
          ),
        ),
      );
      await expectLater(
        find.byType(PolynomialLogo),
        matchesGoldenFile('goldens/polynomial_logo.png'),
      );
    });

    testWidgets('NonlinearLogo', (tester) async {
      await tester.binding.setSurfaceSize(const Size.square(210));

      await tester.pumpWidget(
        const MockWrapper(
          child: NonlinearLogo(
            size: 200,
          ),
        ),
      );
      await expectLater(
        find.byType(NonlinearLogo),
        matchesGoldenFile('goldens/nonlinear_logo.png'),
      );
    });

    testWidgets('SystemsLogo', (tester) async {
      await tester.binding.setSurfaceSize(const Size.square(210));

      await tester.pumpWidget(
        const MockWrapper(
          child: SystemsLogo(
            size: 200,
          ),
        ),
      );
      await expectLater(
        find.byType(SystemsLogo),
        matchesGoldenFile('goldens/system_logo.png'),
      );
    });

    testWidgets('IntegralLogo', (tester) async {
      await tester.binding.setSurfaceSize(const Size.square(210));

      await tester.pumpWidget(
        const MockWrapper(
          child: IntegralLogo(
            size: 200,
          ),
        ),
      );
      await expectLater(
        find.byType(IntegralLogo),
        matchesGoldenFile('goldens/integral_logo.png'),
      );
    });

    testWidgets('OtherLogo', (tester) async {
      await tester.binding.setSurfaceSize(const Size.square(210));

      await tester.pumpWidget(
        const MockWrapper(
          child: OtherLogo(
            size: 200,
          ),
        ),
      );
      await expectLater(
        find.byType(OtherLogo),
        matchesGoldenFile('goldens/other_logo.png'),
      );
    });
  });
}
