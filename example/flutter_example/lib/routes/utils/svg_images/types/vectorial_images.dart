import 'package:equations_solver/routes/utils/svg_images/svg_image.dart';

/// The application logo.
class ApplicationLogo extends SvgImage {
  /// Creates a [ApplicationLogo] widget.
  const ApplicationLogo({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'logo';
}

/// A rotated cartesian plane.
class CartesianPlaneBackground extends SvgImage {
  /// Creates a [CartesianPlaneBackground] widget.
  const CartesianPlaneBackground({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'axis';
}

/// A stylized gaussian curve.
class GaussianCurveBackground extends SvgImage {
  /// Creates a [GaussianCurveBackground] widget.
  const GaussianCurveBackground({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'plot_opacity';
}

/// The "i" symbol of the complex unit in imaginary numbers.
class OtherComplexNumbers extends SvgImage {
  /// Creates a [OtherComplexNumbers] widget.
  const OtherComplexNumbers({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'tools_imaginary';
}

/// A 3x4 matrix with a linear gradient going from green to blue.
class OtherMatrix extends SvgImage {
  /// Creates a [OtherMatrix] widget.
  const OtherMatrix({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'tools_matrix';
}

/// A square matrix whose entries are blue numbers.
class SquareMatrix extends SvgImage {
  /// Creates a [SquareMatrix] widget.
  const SquareMatrix({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'square_matrix';
}

/// The square root with a blue 'x' variable and the black sign.
class SquareRoot extends SvgImage {
  /// Creates a [SquareRoot] widget.
  const SquareRoot({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'square-root-simple';
}

/// A 45 degree angle image.
class HalfRightAngle extends SvgImage {
  /// Creates a [HalfRightAngle] widget.
  const HalfRightAngle({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'angle';
}

/// A cartesian plane with a stylized gaussian curve.
class CartesianPlane extends SvgImage {
  /// Creates an [CartesianPlane] widget.
  const CartesianPlane({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'plot';
}

/// A simple equation in the 'x' variable
class EquationSolution extends SvgImage {
  /// Creates an [EquationSolution] widget.
  const EquationSolution({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'solutions';
}

/// Some atoms linked by a grey line.
class Atoms extends SvgImage {
  /// Creates an [Atoms] widget.
  const Atoms({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'atoms';
}

/// A red cloud with a white cross at the bottom-middle of its body.
class UrlError extends SvgImage {
  /// Creates an [UrlError] widget.
  const UrlError({
    super.key,
    super.size,
  });

  @override
  String get assetName => 'url_error';
}
