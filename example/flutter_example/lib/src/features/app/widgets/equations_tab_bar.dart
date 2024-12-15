import 'package:flutter/material.dart';

class EquationsTabBar extends StatelessWidget {
  const EquationsTabBar({
    required this.tabs,
    super.key,
  });

  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blueGrey,
        ),
      ),
      child: TabBar(
        tabs: tabs,
        indicatorSize: TabBarIndicatorSize.label,
        dividerHeight: 0,
      ),
    );
  }
}
