import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The vectorial logo of the app
class AppLogo extends StatelessWidget {
  const AppLogo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SvgPicture.asset(
        "assets/logo.svg",
        width: 285,
      ),
    );
  }
}
