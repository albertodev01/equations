import 'package:equatable/equatable.dart';
import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/interpolation_page.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/system_page.dart';
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

  /// Route name for the polynomial equations solver.
  static const polynomialPage = '/polynomials';

  /// Route name for the nonlinear equations solver.
  static const nonlinearPage = '/nonlinear';

  /// Route name for the systems page.
  static const systemPage = '/system';

  /// Route name for the integrals page.
  static const integralPage = '/integral';

  /// Route name for the interpolation page.
  static const interpolationPage = '/interpolation';

  /// Making the constructor private since this class is not meant to be
  /// instantiated.
  const RouteGenerator._();

  /// The "dispatcher" that assigns a route name to a particular widget.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute<HomePage>(
          builder: (_) => const HomePage(),
        );

      case polynomialPage:
        return MaterialPageRoute<PolynomialPage>(
          builder: (_) => const PolynomialPage(),
        );

      case nonlinearPage:
        return MaterialPageRoute<NonlinearPage>(
          builder: (_) => const NonlinearPage(),
        );

      case systemPage:
        return MaterialPageRoute<SystemPage>(
          builder: (_) => const SystemPage(),
        );

      case integralPage:
        return MaterialPageRoute<IntegralPage>(
          builder: (_) => const IntegralPage(),
        );

      case interpolationPage:
        return MaterialPageRoute<InterpolationPage>(
          builder: (_) => const InterpolationPage(),
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
