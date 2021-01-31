import 'package:equations_solver/routes.dart';
import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter/material.dart';

/// Contains a series of tiles, represented by a [CardContainer] widget, that
/// route the user to various pages
class HomeContents extends StatelessWidget {
  const HomeContents();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: Wrap(
        spacing: 35,
        runSpacing: 35,
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        children: const [
          CardContainer(
            title: "Polynomials",
            image: PolynomialLogo(),
            destinationRoute: RouteGenerator.polynomialPage,
          ),

          CardContainer(
            title: "Functions",
            image: const NonlinearLogo(),
            destinationRoute: RouteGenerator.homePage,
          ),

          CardContainer(
            title: "Systems",
            image: const SystemsLogo(),
            destinationRoute: RouteGenerator.homePage,
          ),

          CardContainer(
            title: "Integrals",
            image: const IntegralLogo(),
            destinationRoute: RouteGenerator.homePage,
          ),
        ],
      ),
    );
  }
}

