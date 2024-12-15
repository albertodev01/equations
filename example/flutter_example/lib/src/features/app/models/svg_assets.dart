import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Base path of vectorial assets.
const _basePath = 'assets/svg';

sealed class SvgAssetWidget extends StatelessWidget {
  /// Path to the `.svg` file.
  final String _assetPath;

  /// Height of the SVG
  final double width;
  final double height;

  /// Creates a [SvgAssetWidget] widget.
  const SvgAssetWidget(
    this._assetPath, {
    this.width = 40,
    this.height = 40,
    super.key,
  });

  const factory SvgAssetWidget.logo({
    double width,
    double height,
  }) = _LogoSvgAssetWidget;

  const factory SvgAssetWidget.error({
    double width,
    double height,
  }) = _ErrorSvgAssetWidget;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assetPath,
      width: width,
      height: height,
    );
  }
}

class _LogoSvgAssetWidget extends SvgAssetWidget {
  const _LogoSvgAssetWidget({
    super.width,
    super.height,
  }) : super('$_basePath/logo.svg');
}

class _ErrorSvgAssetWidget extends SvgAssetWidget {
  const _ErrorSvgAssetWidget({
    super.width,
    super.height,
  }) : super('$_basePath/error.svg');
}
