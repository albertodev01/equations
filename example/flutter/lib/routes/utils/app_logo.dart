import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The vectorial logo of the app
class AppLogo extends StatelessWidget {
  const AppLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/logo.svg",
      width: 285,
    );
  }
}