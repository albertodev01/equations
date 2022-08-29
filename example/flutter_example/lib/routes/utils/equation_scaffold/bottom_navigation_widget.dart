import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/scaffold_contents.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';

/// The bottom navigation view of the [EquationScaffold] used when the viewport
/// is small enough.
class BottomNavigationWidget extends StatelessWidget {
  /// The tab controller that determines which page is currently visible.
  final TabController tabController;

  /// A list of items for a responsive navigation bar. If the list is empty,
  /// then no navigation bars appear on the screen.
  final List<NavigationItem> navigationItems;

  /// A [FloatingActionButton] widget placed on the bottom-left corner of the
  /// screen.
  final FloatingActionButton? fab;

  /// Creates a [BottomNavigationWidget] widget.
  const BottomNavigationWidget({
    required this.tabController,
    required this.navigationItems,
    this.fab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('TabbedNavigationLayout-Scaffold'),
      body: ScaffoldContents(
        body: TabbedNavigationLayout(
          tabController: tabController,
          navigationItems: navigationItems,
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        navigationItems: navigationItems,
      ),
      floatingActionButton: fab,
    );
  }
}
