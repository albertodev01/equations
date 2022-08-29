import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:flutter/material.dart';

/// This widget is wrapper of a [TabBarView] where the user cannot swipe to
/// change tabs.
///
/// Tabs can be changed only according with the state of the notifier exposed
/// by [InheritedNavigation].
class TabbedNavigationLayout extends StatefulWidget {
  /// Creates a [TabbedNavigationLayout] widget.
  const TabbedNavigationLayout({
    super.key,
  });

  @override
  TabbedNavigationLayoutState createState() => TabbedNavigationLayoutState();
}

/// The state of the [TabbedNavigationLayout] widget.
@visibleForTesting
class TabbedNavigationLayoutState extends State<TabbedNavigationLayout> {
  /// The various pages of the [TabBarView].
  ///
  /// There is no need to update this into 'didUpdateWidget' because tabs won't
  /// change during the app's lifetime.
  late final tabPages = context.inheritedNavigation.navigationItems
      .map((item) => item.content)
      .toList(growable: false);

  /// Changes the currently visible page of the tab.
  void changePage(int pageIndex) {
    context.inheritedNavigation.tabController.animateTo(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: context.inheritedNavigation.navigationIndex,
      builder: (_, value, child) {
        changePage(value);

        return child!;
      },
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: context.inheritedNavigation.tabController,
        children: tabPages,
      ),
    );
  }
}
