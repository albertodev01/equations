import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/scaffold_contents.dart';
import 'package:flutter/material.dart';

/// The rail navigation view of the [EquationScaffold] used when the viewport
/// is big enough.
class RailNavigationWidget extends StatelessWidget {
  /// The tab controller that determines which page is currently visible.
  final TabController tabController;

  /// A list of items for a responsive navigation bar. If the list is empty,
  /// then no navigation bars appear on the screen.
  final List<NavigationItem> navigationItems;

  /// A [FloatingActionButton] widget placed on the bottom-left corner of the
  /// screen.
  final FloatingActionButton? fab;

  /// Creates a [RailNavigationWidget] widget.
  const RailNavigationWidget({
    super.key,
    required this.tabController,
    required this.navigationItems,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('rail navigation rebuild');

    return Scaffold(
      key: const Key('RailNavigationLayout-Scaffold'),
      body: ScaffoldContents(
        body: RailNavigation(
          tabController: tabController,
          navigationItems: navigationItems,
        ),
      ),
      floatingActionButton: fab,
    );
  }
}
