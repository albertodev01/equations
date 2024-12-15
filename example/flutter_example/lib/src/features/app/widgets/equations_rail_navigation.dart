import 'package:equations_solver/src/features/app/widgets/inherited_object.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

class EquationsRailNavigation extends StatefulWidget {
  const EquationsRailNavigation({super.key});

  @override
  State<EquationsRailNavigation> createState() =>
      _EquationsRailNavigationState();
}

class _EquationsRailNavigationState extends State<EquationsRailNavigation> {
  late final destinations = [
    NavigationRailDestination(
      icon: const Icon(Icons.linear_scale_outlined),
      label: Text(context.l10n.polynomialEquationsTitle),
      padding: const EdgeInsets.symmetric(vertical: 4),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.line_axis),
      label: Text(context.l10n.nonlinearEquationsTitle),
      padding: const EdgeInsets.symmetric(vertical: 4),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.grid_3x3),
      label: Text(context.l10n.systemsOfEquationsTitle),
      padding: const EdgeInsets.symmetric(vertical: 4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final index = InheritedObject.of<ValueNotifier<int>>(context).object;

    return ValueListenableBuilder<int>(
      valueListenable: index,
      builder: (context, selectedIndex, _) {
        return NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: (newValue) => index.value = newValue,
          destinations: destinations,
        );
      },
    );
  }
}
