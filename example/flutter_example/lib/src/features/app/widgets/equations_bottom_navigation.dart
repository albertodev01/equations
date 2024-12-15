import 'package:equations_solver/src/features/app/widgets/inherited_object.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

class EquationsBottomNavigation extends StatefulWidget {
  const EquationsBottomNavigation({super.key});

  @override
  State<EquationsBottomNavigation> createState() =>
      _EquationsBottomNavigationState();
}

class _EquationsBottomNavigationState extends State<EquationsBottomNavigation> {
  late final items = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.linear_scale_outlined),
      label: context.l10n.polynomialEquationsTitle,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.line_axis),
      label: context.l10n.nonlinearEquationsTitle,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.grid_3x3),
      label: context.l10n.systemsOfEquationsTitle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final index = InheritedObject.of<ValueNotifier<int>>(context).object;

    return ValueListenableBuilder<int>(
      valueListenable: index,
      builder: (context, currentIndex, _) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (newValue) => index.value = newValue,
          items: items,
        );
      },
    );
  }
}
