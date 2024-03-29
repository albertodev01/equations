import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:equations_solver/routes/home_page/home_contents.dart';
import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/system_page.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'HomeContents' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: SingleChildScrollView(
            child: HomeContents(),
          ),
        ),
      );

      expect(find.byType(CardContainer), findsNWidgets(5));
      expect(find.byType(PolynomialLogo), findsOneWidget);
      expect(find.byType(NonlinearLogo), findsOneWidget);
    });

    testWidgets(
      'Making sure that tapping on the CardContainer widget for '
      'polynomial equations opens a new route',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapperWithNavigator(),
        );
        final finder = find.byKey(const Key('PolynomialLogo-Container'));

        // Tapping an waiting for the animations to complete
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Expecting to be on the new page
        expect(find.byType(PolynomialPage), findsOneWidget);

        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeContents), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that tapping on the CardContainer widget for '
      'nonlinear equations opens a new route',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapperWithNavigator(),
        );
        final finder = find.byKey(const Key('NonlinearLogo-Container'));

        // Tapping an waiting for the animations to complete
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Expecting to be on the new page
        expect(find.byType(NonlinearPage), findsOneWidget);

        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeContents), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that tapping on the CardContainer widget for '
      'systems of equations opens a new route',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapperWithNavigator(),
        );
        final finder = find.byKey(const Key('SystemsLogo-Container'));

        // Tapping an waiting for the animations to complete
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Expecting to be on the new page
        expect(find.byType(SystemPage), findsOneWidget);

        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeContents), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that tapping on the CardContainer widget for '
      'integrals opens a new route',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapperWithNavigator(),
        );
        final finder = find.byKey(const Key('IntegralsLogo-Container'));

        // Tapping an waiting for the animations to complete
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Expecting to be on the new page
        expect(find.byType(IntegralPage), findsOneWidget);

        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeContents), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that tapping on the CardContainer widget for '
      'the analyzers ("Other" page) opens a new route',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapperWithNavigator(),
        );
        final finder = find.byKey(const Key('OtherLogo-Container'));

        // Tapping an waiting for the animations to complete
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();

        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Expecting to be on the new page
        expect(find.byType(OtherPage), findsOneWidget);

        await tester.tap(find.byType(GoBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeContents), findsOneWidget);
      },
    );
  });

  group('Golden tests - HomeContents', () {
    testWidgets('Golden test - HomeContents', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: SingleChildScrollView(
            child: HomeContents(),
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/home_contents.png'),
      );
    });
  });
}
