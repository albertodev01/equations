import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'file:///C:/Users/AlbertoMiola/Desktop/Programmazione/Dart/equations/example/flutter_example/lib/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A rail navigation bar to be displayed within a a [EquationScaffold] widget.
class RailNavigation extends StatelessWidget {
  /// A list of items for a responsive navigation bar
  final List<NavigationItem> navigationItems;
  const RailNavigation({
    required this.navigationItems,
  });

  /// Converts a [NavigationItem] into a [BottomNavigationBarItem]
  List<NavigationRailDestination> get _rail => navigationItems.map((item) {
        return NavigationRailDestination(
          icon: item.icon,
          selectedIcon: item.activeIcon,
          label: Text(item.title),
        );
      }).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // The actual contents of the page
        Expanded(
          child: TabbedNavigationLayout(
            navigationItems: navigationItems,
          ),
        ),

        // The separator between the rail and the contents
        VerticalDivider(
          thickness: 2,
          width: 1,
        ),

        // The rail
        BlocBuilder<NavigationBloc, int>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) => NavigationRail(
            destinations: _rail,
            selectedIndex: state,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (newIndex) =>
                context.read<NavigationBloc>().add(newIndex),
          ),
        ),
      ],
    );
  }
}
