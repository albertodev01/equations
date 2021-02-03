import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Vectorial logo for polynomial equations
class PolynomialLogo extends StatelessWidget {
  final double size;
  const PolynomialLogo({
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/polynomial.svg",
      width: size,
      height: size,
      placeholderBuilder: (_) => const _SvgLoader(),
    );
  }
}

/// Vectorial logo for nonlinear equations
class NonlinearLogo extends StatelessWidget {
  final double size;
  const NonlinearLogo({
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/function.svg",
      width: size,
      height: size,
      placeholderBuilder: (_) => const _SvgLoader(),
    );
  }
}

/// Vectorial logo for systems of equations
class SystemsLogo extends StatelessWidget {
  final double size;
  const SystemsLogo({
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/matrix.svg",
      width: size,
      height: size,
      placeholderBuilder: (_) => const _SvgLoader(),
    );
  }
}

/// Vectorial logo for integrals
class IntegralLogo extends StatelessWidget {
  final double size;
  const IntegralLogo({
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/integral.svg",
      width: size,
      height: size,
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
