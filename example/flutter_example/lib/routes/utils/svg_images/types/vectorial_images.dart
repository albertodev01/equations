import 'package:equations_solver/routes/utils/svg_images/svg_image.dart';
import 'package:flutter/material.dart';

/// A light blue circle with a white arrow pointing upwards.
class ArrowUpSvg extends SvgImage {
  /// Creates an [ArrowUpSvg] widget.
  const ArrowUpSvg({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'arrow_up';
}

/// The "i" symbol of the complex unit in imaginary numbers.
class ToolsComplexNumbers extends SvgImage {
  /// Creates a [ToolsComplexNumbers] widget.
  const ToolsComplexNumbers({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'tools_imaginary';
}

/// A 3x4 matrix with a linear gradient going from green to blue.
class ToolsMatrix extends SvgImage {
  /// Creates a [ToolsMatrix] widget.
  const ToolsMatrix({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'tools_matrix';
}

/// A square matrix whose entries are blue numbers.
class SquareMatrix extends SvgImage {
  /// Creates a [SquareMatrix] widget.
  const SquareMatrix({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'square_matrix';
}

/// The square root with a blue 'x' variable and the black sign.
class SquareRoot extends SvgImage {
  /// Creates a [SquareRoot] widget.
  const SquareRoot({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'square-root-simple';
}

/// A 45 degree angle image.
class HalfRightAngle extends SvgImage {
  /// Creates a [HalfRightAngle] widget.
  const HalfRightAngle({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'angle';
}

/// A cartesian plane with a stylized gaussian curve.
class PlotIcon extends SvgImage {
  /// Creates an [PlotIcon] widget.
  const PlotIcon({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'plot';
}

/// A simple equation in the 'x' variable
class EquationSolution extends SvgImage {
  /// Creates an [EquationSolution] widget.
  const EquationSolution({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'solutions';
}
