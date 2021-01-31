import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/navigation_item.dart';
import 'package:flutter/material.dart';

/// This page contains a series of polynomial equations solvers.
class PolynomialPage extends StatelessWidget {
  const PolynomialPage();

  @override
  Widget build(BuildContext context) {
    return EquationScaffold(
      isHome: false,
      navigationItems: const [
        NavigationItem(
          title: "Test 1",
          icon: Icon(Icons.open_in_new_outlined),
          activeIcon: Icon(Icons.description),
          content: const Center(
            child: Text("one"),
          ),
        ),

        NavigationItem(
            title: "Test 2",
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.description),
            content: const Center(
              child: Text("two"),
            )
        ),

        NavigationItem(
            title: "Test 3",
            icon: Icon(Icons.title),
            activeIcon: Icon(Icons.description),
            content: const Center(
              child: Text("three"),
            )
        ),
      ],
    );
  }
}