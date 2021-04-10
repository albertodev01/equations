import 'package:equatable/equatable.dart';
import 'package:equations_solver/routes/home_page.dart';
import 'package:equations_solver/routes/nonlinear_page.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
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

      default:
        throw const RouteException('Route not found');
    }
  }

  /// Route name for the home page of the app.
  static const homePage = '/';

  /// Route name for the polynomial equations solver.
  static const polynomialPage = '/polynomials';

  /// Route name for the nonlinear equations solver.
  static const nonlinearPage = '/nonlinear';
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
