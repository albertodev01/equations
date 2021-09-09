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
