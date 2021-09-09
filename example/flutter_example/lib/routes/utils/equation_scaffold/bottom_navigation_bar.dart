import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A bottom navigation bar to be displayed within a [EquationScaffold] widget.
class BottomNavigation extends StatefulWidget {
  /// A list of items for a responsive navigation bar.
  final List<NavigationItem> navigationItems;

  /// Creates a [BottomNavigation] widget.
  const BottomNavigation({
    Key? key,
    required this.navigationItems,
  }) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  /// Converts a list of [NavigationItem]s into a list of [BottomNavigationBarItem]s
  /// to be displayed on the navigation bar.
  ///
  /// Since these items will always be the same, we manually cache the list.
  late final _bottom = widget.navigationItems
      .map<BottomNavigationBarItem>(
        (item) => BottomNavigationBarItem(
          icon: item.icon,
          activeIcon: item.activeIcon,
          label: item.title,
        ),
      )
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => BottomNavigationBar(
        elevation: 6,
        items: _bottom,
        type: BottomNavigationBarType.fixed,
        currentIndex: state,
        onTap: (newIndex) => context.read<NavigationCubit>().emit(newIndex),
      ),
    );
  }
}
