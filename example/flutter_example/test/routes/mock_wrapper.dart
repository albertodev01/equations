import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:flutter/material.dart';

/// A wrapper of a [MaterialApp] with localization support to be used in widget
/// tests.
class MockWrapper extends StatelessWidget {
  /// The child to be tested.
  final Widget child;

  /// This is useful when there's the need to make sure that a route is pushed
  /// or popped.
  final List<NavigatorObserver> navigatorObservers;

  /// The initial value of the dropdown.
  ///
  /// By default, this is an empty string.
  final String dropdownInitial;

  /// Creates a [MockWrapper] widget.
  const MockWrapper({
    required this.child,
    this.navigatorObservers = const [],
    this.dropdownInitial = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: navigatorObservers,
      debugShowCheckedModeBanner: false,
      home: InheritedPlotZoom(
        plotZoomState: PlotZoomState(
          minValue: 1,
          maxValue: 10,
          initial: 2,
        ),
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }
}

/// A wrapper of a [MaterialApp] with localization and navigator support to be
/// used in widget tests.
class MockWrapperWithNavigator extends StatelessWidget {
  /// The initial route.
  final String initialRoute;

  /// Creates a [MockWrapperWithNavigator] widget.
  const MockWrapperWithNavigator({
    super.key,
    this.initialRoute = homePagePath,
  });

  @override
  Widget build(BuildContext context) {
    final appRouter = generateRouter(initialRoute: initialRoute);

    return MaterialApp.router(
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
