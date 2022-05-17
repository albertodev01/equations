import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';

/// A bottom navigation bar to be displayed within a [EquationScaffold] widget.
class BottomNavigation extends StatefulWidget {
  /// A list of items for a responsive navigation bar.
  final List<NavigationItem> navigationItems;

  /// Creates a [BottomNavigation] widget.
  const BottomNavigation({
    super.key,
    required this.navigationItems,
  });

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  /// Converts a list of [NavigationItem]s into a list of
  /// [BottomNavigationBarItem]s to be displayed on the navigation bar.
  ///
  /// Since these items will always be the same, we manually cache the list.
  late final _bottom = widget.navigationItems.map<BottomNavigationBarItem>((i) {
    return BottomNavigationBarItem(
      icon: i.icon,
      activeIcon: i.activeIcon,
      label: i.title,
    );
  }).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: context.navigationIndex,
      builder: (context, value, _) {
        return BottomNavigationBar(
          elevation: 6,
          items: _bottom,
          type: BottomNavigationBarType.fixed,
          currentIndex: context.navigationIndex.value,
          onTap: (int newIndex) => context.navigationIndex.value = newIndex,
        );
      },
    );
  }
}
