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
      child: Wrap(
        spacing: 35,
        runSpacing: 35,
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        children: [
          CardContainer(
            title: context.l10n.polynomials,
            image: const PolynomialLogo(),
            destinationRoute: RouteGenerator.polynomialPage,
          ),
          CardContainer(
            title: context.l10n.functions,
            image: const NonlinearLogo(),
            destinationRoute: RouteGenerator.homePage,
          ),
          CardContainer(
            title: context.l10n.systems,
            image: const SystemsLogo(),
            destinationRoute: RouteGenerator.homePage,
          ),
          CardContainer(
            title: context.l10n.integrals,
            image: const IntegralLogo(),
            destinationRoute: RouteGenerator.homePage,
          ),
        ],
      ),
    );
  }
}
