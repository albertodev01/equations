import 'package:equations_solver/routes/utils/svg_images/svg_image.dart';

/// Vectorial logo for polynomial equations.
class PolynomialLogo extends SvgImage {
  /// Creates an [PolynomialLogo] widget.
  const PolynomialLogo({
    double size = 40,
  }) : super(size: size);

  @override
  String get assetName => 'polynomial';
}

/// Vectorial logo for nonlinear equations.
class NonlinearLogo extends SvgImage {
  /// Creates an [NonlinearLogo] widget.
  const NonlinearLogo({
    double size = 40,
  }) : super(size: size);

  @override
  String get assetName => 'function';
}

/// Vectorial logo for systems of equations.
class SystemsLogo extends SvgImage {
  /// Creates an [SystemsLogo] widget.
  const SystemsLogo({
    double size = 40,
  }) : super(size: size);

  @override
  String get assetName => 'matrix';
}

/// Vectorial logo for integrals.
class IntegralLogo extends SvgImage {
  /// Creates an [IntegralLogo] widget.
  const IntegralLogo({
    double size = 40,
  }) : super(size: size);

  @override
  String get assetName => 'integral';
}

/// Vectorial logo for interpolation.
class InterpolationLogo extends SvgImage {
  /// Creates an [InterpolationLogo] widget.
  const InterpolationLogo({
    double size = 40,
  }) : super(size: size);

  @override
  String get assetName => 'plot';
}

/// Vectorial logo for the tools section.
class ToolsLogo extends SvgImage {
  /// Creates an [ToolsLogo] widget.
  const ToolsLogo({
    double size = 40,
  }) : super(size: size);

  @override
  String get assetName => 'tools';
}
