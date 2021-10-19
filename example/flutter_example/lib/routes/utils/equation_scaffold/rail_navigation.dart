import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A rail navigation bar to be displayed within a a [EquationScaffold] widget.
class RailNavigation extends StatefulWidget {
  /// A list of items for a responsive navigation bar.
  final List<NavigationItem> navigationItems;

  /// Controls the position of the currently visible page on the screen.
  final TabController tabController;

  /// Creates a [RailNavigation] widget..
  const RailNavigation({
    Key? key,
    required this.navigationItems,
    required this.tabController,
  }) : super(key: key);

  @override
  _RailNavigationState createState() => _RailNavigationState();
}

class _RailNavigationState extends State<RailNavigation> {
  /// Converts a [NavigationItem] into a [BottomNavigationBarItem].
  late final rails = widget.navigationItems.map<NavigationRailDestination>((i) {
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
        Expanded(
          child: TabbedNavigationLayout(
            navigationItems: widget.navigationItems,
            tabController: widget.tabController,
          ),
        ),

        // The separator between the rail and the contents
        const VerticalDivider(
          thickness: 2,
          width: 1,
        ),

        // The rail
        BlocBuilder<NavigationCubit, int>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) => NavigationRail(
            groupAlignment: 0,
            destinations: rails,
            selectedIndex: state,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (newIndex) {
              context.read<NavigationCubit>().emit(newIndex);
            },
          ),
        ),
      ],
    );
  }
}
