import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Vectorial logo for polynomial equations
class PolynomialLogo extends StatelessWidget {
  const PolynomialLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/polynomial.svg",
      width: 40,
      height: 40,
      placeholderBuilder: (_) => const _SvgLoader(),
    );
  }
}

/// Vectorial logo for nonlinear equations
class NonlinearLogo extends StatelessWidget {
  const NonlinearLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/function.svg",
      width: 40,
      height: 40,
      placeholderBuilder: (_) => const _SvgLoader(),
    );
  }
}

/// Vectorial logo for systems of equations
class SystemsLogo extends StatelessWidget {
  const SystemsLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/matrix.svg",
      width: 40,
      height: 40,
      placeholderBuilder: (_) => const _SvgLoader(),
    );
  }
}

/// Vectorial logo for integrals
class IntegralLogo extends StatelessWidget {
  const IntegralLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/integral.svg",
      width: 40,
      height: 40,
      placeholderBuilder: (_) => const _SvgLoader(),
    );
  }
}

/// A loading spinner to be shown in case the svg parsing required more time
class _SvgLoader extends StatelessWidget {
  const _SvgLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}