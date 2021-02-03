import 'dart:math' as math;
import 'package:equations_solver/blocs/navigation_bar/bloc/navigation_bloc.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:equations_solver/routes/utils/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A simple wrapper of [Scaffold]. This widget is meant to be used across the
/// entire app to setup the minimal "skeleton" of the UI. This scaffold is made
/// up of two parts:
///
///  - an [AppBar] with no title and a dark/light theme switcher;
///  - the body of the [Scaffold]
///
/// When the [isHome] parameter is set to `false`, a back button appears so that
/// the user can navigate one page back.
///
/// This widget also contains a responsive navigation bar which can be either a
/// [BottomNavigationBar] or a [NavigationRail] according with the screen's size.
class EquationScaffold extends StatelessWidget {
  /// The body of the [Scaffold]. When there's a [navigationItems] list defined,
  /// this widget is ignored because the actual body of the scaffold will be
  /// determined by the contents of the list.
  final Widget body;

  /// Tells whether the scaffold is being used in the home page widget or not
  final bool isHome;

  /// A list of items for a responsive navigation bar. If the list is empty,
  /// then no navigation bars appear on the screen.
  final List<NavigationItem> navigationItems;
  const EquationScaffold({
    this.body = const SizedBox(),
    this.isHome = false,
    this.navigationItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    // If there are NO navigation items, then no navigation bars are required
    if (navigationItems.isEmpty) {
      return Scaffold(
        body: _ScaffoldContents(
          isHome: isHome,
          body: body,
        ),
      );
    }

    // At this point, there's at least 1 navigation item and thus the widget
    // requires some responsiveness!
    return BlocProvider<NavigationBloc>(
      create: (_) => NavigationBloc(),
      child: LayoutBuilder(
        builder: (context, dimensions) {
          // If the dimension of the screen is "small" enough, a bottom navigation
          // bar fits better
          debugPrint("width = ${dimensions.maxWidth}");

          if (dimensions.maxWidth < 600) {
            return Scaffold(
              body: _ScaffoldContents(
                isHome: isHome,
                body: TabbedNavigationLayout(
                  navigationItems: navigationItems,
                ),
              ),
              bottomNavigationBar: BottomNavigation(
                navigationItems: navigationItems,
              ),
            );
          }

          return Scaffold(
            body: _ScaffoldContents(
              isHome: isHome,
              body: RailNavigation(
                navigationItems: navigationItems,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The content of the [EquationScaffold] scaffold, which is simply a [Stack]
/// with two children:
///
///   - A background widget that draws an SVG image as background
///   - A foreground widget which is the actual content of the page
class _ScaffoldContents extends StatelessWidget {
  /// The body of the [Scaffold]
  final Widget body;

  /// Tells whether the scaffold is being used in the home page widget or not
  final bool isHome;
  const _ScaffoldContents({
    required this.body,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // The background image of the page
          const Positioned(
            bottom: -70,
            left: -30,
            child: _ScaffoldBackground(),
          ),

          // The actual contents in the foreground
          Positioned.fill(
            child: _ScaffoldForeground(
              isHome: isHome,
              body: body,
            ),
          ),
        ],
      ),
    );
  }
}

/// The contents of the scaffold in the foreground
class _ScaffoldForeground extends StatelessWidget {
  /// The body of the [Scaffold]
  final Widget body;

  /// Tells whether the scaffold is being used in the home page widget or not
  final bool isHome;
  const _ScaffoldForeground({
    required this.body,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The 'header' bar
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
          child: Row(
            children: [
              if (!isHome) const BackButton(),
            ],
          ),
        ),

        // The body of the app
        Expanded(
          child: body,
        ),
      ],
    );
  }
}

/// The contents of the scaffold in the background
class _ScaffoldBackground extends StatelessWidget {
  const _ScaffoldBackground();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height / 1.2;

    return Transform.rotate(
      angle: -math.pi / 8,
      child: SvgPicture.asset(
        "assets/axis.svg",
        height: size,
        width: size,
      ),
    );
  }
}
