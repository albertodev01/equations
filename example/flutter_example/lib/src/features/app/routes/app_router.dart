import 'package:equations_solver/src/features/app/routes/routes.dart';
import 'package:equations_solver/src/features/app/view/equations_app_view.dart';
import 'package:equations_solver/src/features/app/view/error_view.dart';
import 'package:equations_solver/src/features/app/widgets/navigation/shell_route_scaffold.dart';
import 'package:equations_solver/src/features/complex_numbers/view/complex_numbers_view.dart';
import 'package:equations_solver/src/features/integral/view/integrals_view.dart';
import 'package:equations_solver/src/features/interpolation/view/interpolation_view.dart';
import 'package:equations_solver/src/features/matrices/view/matrices_view.dart';
import 'package:equations_solver/src/features/nonlinear/view/nonlinear_view.dart';
import 'package:equations_solver/src/features/polynomial/view/polynomials_view.dart';
import 'package:equations_solver/src/features/system/view/systems_view.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _bottomNavigatorKey = GlobalKey<NavigatorState>();

/// The [GoRouter] object that manages the navigation within the application.
/// The [MaterialApp] widget in [EquationsAppView] should use this variable
/// instead of the [generateAppRouter] function.
///
/// When writing tests, use [generateAppRouter] to create a new [GoRouter]
/// configuration and do **NOT** use [appRouter].
final appRouter = generateAppRouter();

/// Generates a [GoRouter] object that defines the application's routes
/// configuration.
///
/// The returned value of this function is used by [appRouter] and by widget
/// tests (to avoid working with global state).
///
/// When writing tests, use [generateAppRouter] to create a new [GoRouter]
/// configuration and do **NOT** use [appRouter].
@visibleForTesting
GoRouter generateAppRouter({
  String initialLocation = homeRoute,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    navigatorKey: _rootNavigatorKey,
    errorBuilder: (_, __) => const ErrorView(),
    routes: [
      ShellRoute(
        navigatorKey: _bottomNavigatorKey,
        pageBuilder: (context, state, child) => NoTransitionPage(
          key: state.pageKey,
          child: ShellRouteScaffold(
            title: context.l10n.title,
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: homeRoute,
            parentNavigatorKey: _bottomNavigatorKey,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DefaultTabController(
                length: 4,
                child: PolynomialsView(),
              ),
            ),
          ),
          GoRoute(
            path: nonlinearRoute,
            parentNavigatorKey: _bottomNavigatorKey,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DefaultTabController(
                length: 2,
                child: NonlinearView(),
              ),
            ),
          ),
          GoRoute(
            path: systemsRoute,
            parentNavigatorKey: _bottomNavigatorKey,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DefaultTabController(
                length: 2,
                child: SystemsView(),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: integralsRoute,
        builder: (_, __) => const IntegralsView(),
      ),
      GoRoute(
        path: complexNumbersRoute,
        builder: (_, __) => const ComplexNumbersView(),
      ),
      GoRoute(
        path: matricesRoute,
        builder: (_, __) => const MatricesView(),
      ),
      GoRoute(
        path: interpolationRoute,
        builder: (_, __) => const InterpolationView(),
      ),
      GoRoute(
        path: errorRoute,
        builder: (_, __) => const ErrorView(),
      ),
    ],
  );
}
