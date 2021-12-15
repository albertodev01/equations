import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes.dart';
import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';

/// Contains a series of tiles, represented by a [CardContainer] widget, that
/// route the user to the desired pages.
class HomeContents extends StatelessWidget {
  /// Creates a [HomeContents] widget.
  const HomeContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CardContainer(
            key: const Key('PolynomialLogo-Container'),
            title: context.l10n.polynomials,
            image: const PolynomialLogo(),
            onTap: () => Navigator.of(context).pushNamed(
              RouteGenerator.polynomialPage,
            ),
          ),
          CardContainer(
            key: const Key('NonlinearLogo-Container'),
            title: context.l10n.functions,
            image: const NonlinearLogo(),
            onTap: () => Navigator.of(context).pushNamed(
              RouteGenerator.nonlinearPage,
            ),
          ),
          CardContainer(
            key: const Key('SystemsLogo-Container'),
            title: context.l10n.systems,
            image: const SystemsLogo(),
            onTap: () => Navigator.of(context).pushNamed(
              RouteGenerator.systemPage,
            ),
          ),
          CardContainer(
            key: const Key('IntegralsLogo-Container'),
            title: context.l10n.integrals,
            image: const IntegralLogo(),
            onTap: () => Navigator.of(context).pushNamed(
              RouteGenerator.integralPage,
            ),
          ),
          CardContainer(
            key: const Key('OtherLogo-Container'),
            title: context.l10n.other,
            image: const OtherLogo(),
            onTap: () => Navigator.of(context).pushNamed(
              RouteGenerator.otherPage,
            ),
          ),
        ],
      ),
    );
  }
}
