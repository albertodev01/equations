import 'package:equations_solver/routes/home_page/home_contents.dart';
import 'package:equations_solver/routes/utils/app_logo.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// The home page shows a series of cards representing the various solvers
/// implemented in the app.
class HomePage extends StatelessWidget {
  /// Creates a [HomePage] widget.
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EquationScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              // The logo at the top
              AppLogo(),

              // The body of the home, which is a series of cards redirecting
              // the users to the various solvers
              HomeContents(),
            ],
          ),
        ),
      ),
    );
  }
}
