import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';

/// This widget is wrapper of a [TabBarView] where the user cannot swipe to
/// change tabs.
///
/// Tabs can be changed only according with the state of a [NavigationBloc] bloc.
class TabbedNavigationLayout extends StatefulWidget {
  /// A list of items for a responsive navigation bar.
  final List<NavigationItem> navigationItems;

  /// Controls the position of the currently visible page on the screen.
  final TabController tabController;

  /// Creates a [TabbedNavigationLayout] widget.
  const TabbedNavigationLayout({
    super.key,
    required this.navigationItems,
    required this.tabController,
  });

  @override
  TabbedNavigationLayoutState createState() => TabbedNavigationLayoutState();
}

/// The state of the [TabbedNavigationLayout] widget.
@visibleForTesting
class TabbedNavigationLayoutState extends State<TabbedNavigationLayout> {
  /// The various pages of the [TabBarView].
  late final tabPages = widget.navigationItems
      .map((item) => item.content)
      .toList(growable: false);

  /// Changes the currently visible page of the tab.
  void changePage(int pageIndex) => widget.tabController.animateTo(pageIndex);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: context.navigationIndex,
      builder: (_, value, child) {
        changePage(value);
        return child!;
      },
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: widget.tabController,
        children: tabPages,
      ),
    );
  }
}
