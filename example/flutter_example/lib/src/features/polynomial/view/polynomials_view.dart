import 'package:equations_solver/src/features/app/widgets/equations_tab_bar.dart';
import 'package:equations_solver/src/features/polynomial/widgets/equation_tab_body.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

class PolynomialsView extends StatelessWidget {
  const PolynomialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          _TabBar(),
          SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              children: [
                EquationTabBody(degree: 1),
                EquationTabBody(degree: 2),
                EquationTabBody(degree: 3),
                EquationTabBody(degree: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return EquationsTabBar(
      tabs: [
        Tab(text: context.l10n.firstDegree),
        Tab(text: context.l10n.secondDegree),
        Tab(text: context.l10n.thirdDegree),
        Tab(text: context.l10n.fourthDegree),
      ],
    );
  }
}
