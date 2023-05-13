import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';

/// A rail navigation bar to be displayed within an [EquationScaffold] widget.
class RailNavigation extends StatefulWidget {
  /// Creates a [RailNavigation] widget.
  const RailNavigation({
    super.key,
  });

  @override
  State<RailNavigation> createState() => _RailNavigationState();
}

class _RailNavigationState extends State<RailNavigation> {
  /// Converts a [NavigationItem] into a [BottomNavigationBarItem].
  ///
  /// There is no need to update this into 'didUpdateWidget' because navigation
  /// items won't change during the app's lifetime.
  late final rails = context.inheritedNavigation.navigationItems
      .map<NavigationRailDestination>((i) {
    return NavigationRailDestination(
      icon: i.icon,
      selectedIcon: i.activeIcon,
      label: Text(i.title),
    );
  }).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // The actual contents of the page
        const Expanded(
          child: TabbedNavigationLayout(),
        ),

        // The separator between the rail and the contents
        const VerticalDivider(
          thickness: 2,
          width: 1,
        ),

        // The navigation rail
        ValueListenableBuilder<int>(
          valueListenable: context.inheritedNavigation.navigationIndex,
          builder: (context, value, _) {
            return NavigationRail(
              groupAlignment: 0,
              destinations: rails,
              selectedIndex: value,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (newIndex) =>
                  context.inheritedNavigation.navigationIndex.value = newIndex,
            );
          },
        ),
      ],
    );
  }
}
