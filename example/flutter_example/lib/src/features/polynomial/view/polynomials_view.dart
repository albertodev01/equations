import 'package:equations_solver/src/features/app/widgets/equations_tab_bar.dart';
import 'package:equations_solver/src/features/polynomial/widgets/linear_equation_tab.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

class PolynomialsView extends StatelessWidget {
  const PolynomialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          EquationsTabBar(
            tabs: [
              Tab(text: context.l10n.firstDegree),
              Tab(text: context.l10n.secondDegree),
              Tab(text: context.l10n.thirdDegree),
              Tab(text: context.l10n.fourthDegree),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                LinearEquationTab(),
                Text('b'),
                Text('c'),
                Text('d'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
