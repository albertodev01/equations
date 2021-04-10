import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget is wrapper of a [TabBarView] where the user cannot swipe to
/// change tabs.
///
/// Tabs can be changed only according with the state of a [NavigationBloc] bloc.
class TabbedNavigationLayout extends StatefulWidget {
  /// A list of items for a responsive navigation bar.
  final List<NavigationItem> navigationItems;

  /// Creates a [TabbedNavigationLayout] widget.
  const TabbedNavigationLayout({
    required this.navigationItems,
  });

  @override
  TabbedNavigationLayoutState createState() => TabbedNavigationLayoutState();
}

/// The state of the [TabbedNavigationLayout] widget.
@visibleForTesting
class TabbedNavigationLayoutState extends State<TabbedNavigationLayout>
    with SingleTickerProviderStateMixin {
  /// Controls the position of the currently visible page of the [TabBarView].
  late final TabController tabController;

  /// The various pages of the [TabBarView].
  late final tabPages = widget.navigationItems
      .map((item) => item.content)
      .toList(growable: false);

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: widget.navigationItems.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  /// Changes the currently visible page of the tab.
  void changePage(int pageIndex) => tabController.animateTo(pageIndex);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) => changePage(state),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: tabPages,
      ),
    );
  }
}
