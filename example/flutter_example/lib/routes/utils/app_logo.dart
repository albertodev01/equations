import 'package:equations_solver/routes/home_page.dart';
import 'package:flutter/material.dart';

/// The app logo at the top of the [HomePage] widget.
class AppLogo extends StatelessWidget {
  /// Creates an [AppLogo] widget.
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 25,
      ),
      child: Image(
        image: AssetImage('assets/png/logo.png'),
        height: 68,
        width: 256,
      ),
    );
  }
}
