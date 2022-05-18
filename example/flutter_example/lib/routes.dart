import 'package:equations_solver/routes/error_page.dart';
import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/system_page.dart';
import 'package:go_router/go_router.dart';

/// Route name for the home page of the app.
const homePagePath = '/';

/// Route name for the integrals page.
const integralPagePath = '/integrals';

/// Route name for the nonlinear equations solver page.
const nonlinearPagePath = '/nonlinears';

/// Route name for the polynomial equations solver page.
const polynomialPagePath = '/polynomials';

/// Route name for the systems page.
const systemPagePath = '/systems';

/// Route name for the page containing various utilities.
const otherPagePath = '/other';

/// Generates the [GoRouter] instance that manages the app navigation.
GoRouter generateRouter({String initialRoute = homePagePath}) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: homePagePath,
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: integralPagePath,
        builder: (_, __) => const IntegralPage(),
      ),
      GoRoute(
        path: nonlinearPagePath,
        builder: (_, __) => const NonlinearPage(),
      ),
      GoRoute(
        path: polynomialPagePath,
        builder: (_, __) => const PolynomialPage(),
      ),
      GoRoute(
        path: systemPagePath,
        builder: (_, __) => const SystemPage(),
      ),
      GoRoute(
        path: otherPagePath,
        builder: (_, __) => const OtherPage(),
      ),
    ],
    urlPathStrategy: UrlPathStrategy.path,
    errorBuilder: (_, __) => const ErrorPage(),
  );
}
