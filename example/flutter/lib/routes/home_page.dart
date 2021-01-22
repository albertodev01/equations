import 'package:equations_solver/routes/home_page/home_contents.dart';
import 'package:equations_solver/routes/home_page/recent_actions.dart';
import 'package:equations_solver/routes/utils/app_logo.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// TODO
class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return EquationScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // The logo at the top
            AppLogo(),

            // The body of the home, which is a series of cards redirecting the
            // users to the various solvers
            HomeContents(),

            // Shows the last 5 actions made with the app
            RecentActions(),
          ],
        ),
      ),
    );
  }
}
