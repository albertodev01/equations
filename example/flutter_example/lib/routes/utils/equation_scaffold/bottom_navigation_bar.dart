import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A bottom navigation bar to be displayed withina a [EquationScaffold] widget.
class BottomNavigation extends StatelessWidget {
  /// A list of items for a responsive navigation bar
  final List<NavigationItem> navigationItems;
  const BottomNavigation({
    required this.navigationItems,
  });

  /// Converts a [NavigationItem] into a [BottomNavigationBarItem]
  List<BottomNavigationBarItem> get _bottom => navigationItems.map((item) {
    return BottomNavigationBarItem(
      icon: item.icon,
      activeIcon: item.activeIcon,
      label: item.title,
    );
  }).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, int>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => BottomNavigationBar(
        items: _bottom,
        currentIndex: state,
        onTap: (newIndex) => context.read<NavigationBloc>().add(newIndex),
      ),
    );
  }
}