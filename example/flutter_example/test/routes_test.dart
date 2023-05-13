import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes.dart';
import 'package:equations_solver/routes/error_page.dart';
import 'package:equations_solver/routes/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Making sure that route names are consistent', () {
    test('Verifying route names', () {
      expect(homePagePath, equals('/'));
      expect(polynomialPagePath, equals('/polynomials'));
      expect(nonlinearPagePath, equals('/nonlinears'));
      expect(systemPagePath, equals('/systems'));
      expect(integralPagePath, equals('/integrals'));
      expect(otherPagePath, equals('/other'));
    });

    test('Making sure that the generator produces correct routes', () {
      final appRoutes = generateRouter();
      expect(appRoutes.routeConfiguration.routes.length, equals(6));

      // Exact routes
      /*expect(
        appRoutes.routeConfiguration.routes.any(
          (r) => r.path == polynomialPagePath,
        ),
        isTrue,
      );*/
    });

    testWidgets(
      'Making sure that invalid paths redirect to the error page',
      (tester) async {
        final router = generateRouter();

        await tester.pumpWidget(
          MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );

        // Home page
        router.go(homePagePath);
        await tester.pumpAndSettle();
        expect(find.byType(HomePage), findsOneWidget);

        // Wrong address
        router.go('/does-not-exist');
        await tester.pumpAndSettle();
        expect(find.byType(ErrorPage), findsOneWidget);
      },
    );
  });
}
