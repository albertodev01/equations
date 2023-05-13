import 'package:equations_solver/routes/error_page.dart';
import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/system_page.dart';
import 'package:flutter/widgets.dart';
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

/// Builds a [FadeTransition] for a [GoRoute] route.
CustomTransitionPage<void> _builder(
  BuildContext _,
  GoRouterState state,
  Widget childPage,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionsBuilder: (context, animation, _, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    child: childPage,
  );
}

/// Generates the [GoRouter] instance that manages the app navigation.
GoRouter generateRouter({String initialRoute = homePagePath}) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: homePagePath,
        pageBuilder: (_, state) => _builder(_, state, const HomePage()),
      ),
      GoRoute(
        path: integralPagePath,
        pageBuilder: (_, state) => _builder(_, state, const IntegralPage()),
      ),
      GoRoute(
        path: nonlinearPagePath,
        pageBuilder: (_, state) => _builder(_, state, const NonlinearPage()),
      ),
      GoRoute(
        path: polynomialPagePath,
        pageBuilder: (_, state) => _builder(_, state, const PolynomialPage()),
      ),
      GoRoute(
        path: systemPagePath,
        pageBuilder: (_, state) => _builder(_, state, const SystemPage()),
      ),
      GoRoute(
        path: otherPagePath,
        pageBuilder: (_, state) => _builder(_, state, const OtherPage()),
      ),
    ],
    errorBuilder: (_, __) => const ErrorPage(),
  );
}
