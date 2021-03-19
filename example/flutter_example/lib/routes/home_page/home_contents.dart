import 'package:flutter/material.dart';
import 'package:equations_solver/routes.dart';
import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:equations_solver/localization/localization.dart';

/// Contains a series of tiles, represented by a [CardContainer] widget, that
/// route the user to various pages
class HomeContents extends StatelessWidget {
  const HomeContents();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 40, 25, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CardContainer(
            title: context.l10n.polynomials,
            image: const PolynomialLogo(),
            onTap: () =>
                Navigator.of(context).pushNamed(RouteGenerator.polynomialPage),
          ),
          CardContainer(
            title: context.l10n.functions,
            image: const NonlinearLogo(),
            onTap: () {},
          ),
          CardContainer(
            title: context.l10n.systems,
            image: const SystemsLogo(),
            onTap: () {},
          ),
          CardContainer(
            title: context.l10n.integrals,
            image: const IntegralLogo(),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
