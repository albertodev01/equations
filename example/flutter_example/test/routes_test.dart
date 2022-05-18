import 'package:equations_solver/routes.dart';
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
      expect(appRoutes.routerDelegate.routes.length, equals(6));
      expect(appRoutes.routerDelegate.errorBuilder, isNotNull);

      // Exact routes
      expect(
        appRoutes.routerDelegate.routes.any((r) => r.path == homePagePath),
        isTrue,
      );
      expect(
        appRoutes.routerDelegate.routes
            .any((r) => r.path == polynomialPagePath),
        isTrue,
      );
      expect(
        appRoutes.routerDelegate.routes.any((r) => r.path == nonlinearPagePath),
        isTrue,
      );
      expect(
        appRoutes.routerDelegate.routes.any((r) => r.path == systemPagePath),
        isTrue,
      );
      expect(
        appRoutes.routerDelegate.routes.any((r) => r.path == integralPagePath),
        isTrue,
      );
      expect(
        appRoutes.routerDelegate.routes.any((r) => r.path == otherPagePath),
        isTrue,
      );
    });
  });
}
