import 'package:equatable/equatable.dart';
import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/interpolation_page.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/system_page.dart';
import 'package:equations_solver/routes/tools_page.dart';
import 'package:flutter/material.dart';

/// Route management class that handles the navigation among various pages of the
/// app. New routes should be opened in the following ways:
///
/// ```dart
/// Navigator.of(context).pushNamed(RouteGenerator.homePage);
/// Navigator.pushNamed(context, RouteGenerator.homePage);
/// ```
///
/// No differences since both ways are valid.
abstract class RouteGenerator {
  /// Route name for the home page of the app.
  static const homePage = '/';

  /// Route name for the integrals page.
  static const integralPage = '/integral';

  /// Route name for the interpolation page.
  static const interpolationPage = '/interpolation';

  /// Route name for the nonlinear equations solver page.
  static const nonlinearPage = '/nonlinear';

  /// Route name for the polynomial equations solver page.
  static const polynomialPage = '/polynomials';

  /// Route name for the systems page.
  static const systemPage = '/system';

  /// Route name for the tools page.
  static const toolsPage = '/tools';

  /// Making the constructor private since this class is not meant to be
  /// instantiated.
  const RouteGenerator._();

  /// The transition animation between two pages.
  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// The "dispatcher" that assigns a route name to a particular widget.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return PageRouteBuilder<HomePage>(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: _slideTransition,
        );

      case polynomialPage:
        return PageRouteBuilder<PolynomialPage>(
          pageBuilder: (_, __, ___) => const PolynomialPage(),
          transitionsBuilder: _slideTransition,
        );

      case nonlinearPage:
        return PageRouteBuilder<NonlinearPage>(
          pageBuilder: (_, __, ___) => const NonlinearPage(),
          transitionsBuilder: _slideTransition,
        );

      case systemPage:
        return PageRouteBuilder<SystemPage>(
          pageBuilder: (_, __, ___) => const SystemPage(),
          transitionsBuilder: _slideTransition,
        );

      case integralPage:
        return PageRouteBuilder<IntegralPage>(
          pageBuilder: (_, __, ___) => const IntegralPage(),
          transitionsBuilder: _slideTransition,
        );

      case interpolationPage:
        return PageRouteBuilder<InterpolationPage>(
          pageBuilder: (_, __, ___) => const InterpolationPage(),
          transitionsBuilder: _slideTransition,
        );

      case toolsPage:
        return PageRouteBuilder<ToolsPage>(
          pageBuilder: (_, __, ___) => const ToolsPage(),
          transitionsBuilder: _slideTransition,
        );

      default:
        throw const RouteException('Route not found');
    }
  }
}

/// Exception to be thrown when the route being pushed doesn't exist.
class RouteException extends Equatable implements Exception {
  /// The error message.
  final String message;

  /// Requires the error [message] to be shown when a route is not found.
  const RouteException(this.message);

  @override
  List<Object?> get props => [message];
}
