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

/// The "x^2" equation with the superscript "2" in blue.
class ToolsSquareX extends SvgImage {
  /// Creates a [ToolsSquareX] widget.
  const ToolsSquareX({
    Key? key,
    double size = 40,
  }) : super(key: key, size: size);

  @override
  String get assetName => 'tools_poly';
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
