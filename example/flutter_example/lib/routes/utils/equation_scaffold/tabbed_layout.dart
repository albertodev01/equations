import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'file:///C:/Users/AlbertoMiola/Desktop/Programmazione/Dart/equations/example/flutter_example/lib/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabbedNavigationLayout extends StatefulWidget {
  /// A list of items for a responsive navigation bar
  final List<NavigationItem> navigationItems;
  const TabbedNavigationLayout({
    required this.navigationItems,
  });

  @override
  _TabbedNavigationLayoutState createState() => _TabbedNavigationLayoutState();
}

class _TabbedNavigationLayoutState extends State<TabbedNavigationLayout>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final List<Widget> tabPages;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: widget.navigationItems.length,
      vsync: this,
    );

    tabPages = widget.navigationItems
        .map((item) => item.content)
        .toList(growable: false);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _changePage(int pageIndex) => tabController.animateTo(pageIndex);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, int>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) => _changePage(state),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: tabPages,
      ),
    );
  }
}
