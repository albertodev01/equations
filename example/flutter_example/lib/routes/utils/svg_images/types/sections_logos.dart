import 'package:equations_solver/routes/utils/svg_images/svg_image.dart';

/// Vectorial logo for polynomial equations.
class PolynomialLogo extends SvgImage {
  /// Creates an [PolynomialLogo] widget.
  const PolynomialLogo({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'polynomial';
}

/// Vectorial logo for nonlinear equations.
class NonlinearLogo extends SvgImage {
  /// Creates an [NonlinearLogo] widget.
  const NonlinearLogo({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'function';
}

/// Vectorial logo for systems of equations.
class SystemsLogo extends SvgImage {
  /// Creates an [SystemsLogo] widget.
  const SystemsLogo({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'matrix';
}

/// Vectorial logo for integrals.
class IntegralLogo extends SvgImage {
  /// Creates an [IntegralLogo] widget.
  const IntegralLogo({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'integral';
}

/// Vectorial logo for the "other" section.
class OtherLogo extends SvgImage {
  /// Creates an [OtherLogo] widget.
  const OtherLogo({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'wrench';
}
