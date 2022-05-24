import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The vectorial logo of the app.
class AppLogo extends StatelessWidget {
  /// Creates an [AppLogo] widget.
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: SvgPicture.asset(
        'assets/logo.svg',
        height: 90,
      ),
    );
  }
}
