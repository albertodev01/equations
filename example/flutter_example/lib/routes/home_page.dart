import 'package:equations_solver/routes/home_page/home_contents.dart';
import 'package:equations_solver/routes/utils/app_logo.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// The home page shows a series of cards representing the various solvers of
/// the app.
class HomePage extends StatelessWidget {
  /// Creates a [HomePage] widget.
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EquationScaffold(
      body: CustomScrollView(
        slivers: [
          // We're using 'SliverFillRemaining' because it makes the contents
          // fill the entire viewport and, on desktop or web, the scroll bar
          // appears on the right edge of the window (while the contents ALWAYS
          // stay at the center).
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The logo at the top
                  AppLogo(),

                  // The body of the home, which is a series of cards
                  // redirecting the users to the various solvers
                  HomeContents(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
