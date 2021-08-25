import 'package:equations_solver/routes/utils/svg_images/svg_image.dart';

/// A light blue circle with a white arrow pointing upwards.
class ArrowUpSvg extends SvgImage {
  /// Creates an [ArrowUpSvg] widget.
  const ArrowUpSvg({
    double size = 40,
  }) : super(size: size);

  @override
  String get assetName => 'arrow_up';
}
