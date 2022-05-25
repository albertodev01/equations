import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A base class for all of the SVG wrapper widgets.
abstract class SvgImage extends StatelessWidget {
  /// The size of the svg image.
  ///
  /// By default, this is set to `40`.
  final double size;

  /// Creates a [SvgImage] widget,
  const SvgImage({
    super.key,
    this.size = 40,
  });

  /// The name of the Svg asset file.
  String get assetName;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/$assetName.svg',
      height: size,
      width: size,
    );
  }
}
