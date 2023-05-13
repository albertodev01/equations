import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes.dart';
import 'package:equations_solver/routes/home_page/card_containers.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Contains a series of tiles, represented by a [CardContainer] widget, that
/// route the user to the desired pages.
class HomeContents extends StatelessWidget {
  /// Creates a [HomeContents] widget.
  const HomeContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CardContainer(
            key: const Key('PolynomialLogo-Container'),
            title: context.l10n.polynomials,
            image: const PolynomialLogo(),
            onTap: () async => context.push(polynomialPagePath),
          ),
          CardContainer(
            key: const Key('NonlinearLogo-Container'),
            title: context.l10n.functions,
            image: const NonlinearLogo(),
            onTap: () async => context.push(nonlinearPagePath),
          ),
          CardContainer(
            key: const Key('SystemsLogo-Container'),
            title: context.l10n.systems,
            image: const SystemsLogo(),
            onTap: () async => context.push(systemPagePath),
          ),
          CardContainer(
            key: const Key('IntegralsLogo-Container'),
            title: context.l10n.integrals,
            image: const IntegralLogo(),
            onTap: () async => context.push(integralPagePath),
          ),
          CardContainer(
            key: const Key('OtherLogo-Container'),
            title: context.l10n.other,
            image: const OtherLogo(),
            onTap: () async => context.push(otherPagePath),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('${context.l10n.version}: 1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}
