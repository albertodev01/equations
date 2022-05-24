import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_widget.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation_widget.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/scaffold_contents.dart';
import 'package:flutter/material.dart';

const _assertionError = 'There must be at least 1 navigation item.';

/// A simple wrapper of [Scaffold]. This widget is meant to be used across the
/// entire app to setup the minimal "skeleton" of the UI. This scaffold is made
/// up of two parts:
///
///  - an [AppBar] with no title and a dark/light theme switcher;
///  - the body of the [Scaffold];
///  - an optional [FloatingActionButton].
///
/// This widget also contains a responsive navigation bar which can be either a
/// [BottomNavigationBar] or a [NavigationRail] according with the screen's
/// size.
class EquationScaffold extends StatefulWidget {
  /// The body of the [Scaffold]. When there's a [navigationItems] list defined,
  /// this widget is ignored because the actual body of the scaffold will be
  /// determined by the contents of the list.
  final Widget body;

  /// A list of items for a responsive navigation bar. If the list is empty,
  /// then no navigation bars appear on the screen.
  final List<NavigationItem> navigationItems;

  /// A [FloatingActionButton] widget placed on the bottom-left corner of the
  /// screen.
  final FloatingActionButton? fab;

  /// Creates a custom [Scaffold] widget with no built-in navigation.
  const EquationScaffold({
    super.key,
    required this.body,
    this.fab,
  }) : navigationItems = const [];

  /// Creates a custom [Scaffold] widget with built-in tabbed navigation. There
  /// must be at least 1 navigation item.
  const EquationScaffold.navigation({
    super.key,
    required this.navigationItems,
    this.fab,
  })  : body = const SizedBox.shrink(),
        assert(
          navigationItems.length > 0,
          _assertionError,
        );

  @override
  _EquationScaffoldState createState() => _EquationScaffoldState();
}

class _EquationScaffoldState extends State<EquationScaffold>
    with SingleTickerProviderStateMixin {
  /// Controls the position of the currently visible page.
  late final tabController = TabController(
    length: widget.navigationItems.length,
    vsync: this,
  );

  /// Caching the bottom navigation view.
  late BottomNavigationWidget bottomNavigationWidget = BottomNavigationWidget(
    navigationItems: widget.navigationItems,
    tabController: tabController,
    fab: widget.fab,
  );

  /// Caching the rail navigation view.
  late RailNavigationWidget railNavigationWidget = RailNavigationWidget(
    navigationItems: widget.navigationItems,
    tabController: tabController,
    fab: widget.fab,
  );

  @override
  void didUpdateWidget(covariant EquationScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.navigationItems != oldWidget.navigationItems ||
        widget.fab != oldWidget.fab) {
      bottomNavigationWidget = BottomNavigationWidget(
        navigationItems: widget.navigationItems,
        tabController: tabController,
        fab: widget.fab,
      );

      railNavigationWidget = RailNavigationWidget(
        navigationItems: widget.navigationItems,
        tabController: tabController,
        fab: widget.fab,
      );
    }
  }

  @override
  void dispose() {
    // The 'tabController' is lazily initialized and it may never be used if
    // there are no navigation items. For this reason, it has to be disposed
    // only when a tabbed layout is used, which is when there are navigation
    // items defined.
    if (widget.navigationItems.isNotEmpty) {
      tabController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If there are NO navigation items, then no navigation bars are required
    if (widget.navigationItems.isEmpty) {
      return Scaffold(
        body: ScaffoldContents(
          body: widget.body,
        ),
        floatingActionButton: widget.fab,
      );
    }

    // At this point, there's at least 1 navigation item and thus the widget
    // requires some responsiveness!
    return InheritedNavigation(
      navigationIndex: ValueNotifier<int>(0),
      child: LayoutBuilder(
        builder: (context, dimensions) {
          // If the dimension of the screen is "small" enough, a bottom
          // navigation bar fits better
          if (dimensions.maxWidth <= bottomNavigationBreakpoint) {
            return bottomNavigationWidget;
          }

          return railNavigationWidget;
        },
      ),
    );
  }
}
