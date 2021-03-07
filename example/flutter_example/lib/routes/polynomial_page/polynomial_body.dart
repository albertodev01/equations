import 'package:equations_solver/routes/polynomial_page/data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';

/// TODO write docs
class PolynomialBody extends StatefulWidget {
  const PolynomialBody();

  @override
  _PolynomialBodyState createState() => _PolynomialBodyState();
}

class _PolynomialBodyState extends State<PolynomialBody> {
  /// Manually caching the page title
  late final Widget pageTitleWidget = _PageTitle(
    pageTitle: getLocalizedName(context),
  );

  /// Getting the title of the page according with the type of polynomial that
  /// is going to be solved.
  String getLocalizedName(BuildContext context) {
    final polynomialType = context.read<PolynomialBloc>().polynomialType;

    switch (polynomialType) {
      case PolynomialType.linear:
        return context.l10n.firstDegree;
      case PolynomialType.quadratic:
        return context.l10n.secondDegree;
      case PolynomialType.cubic:
        return context.l10n.thirdDegree;
      case PolynomialType.quartic:
        return context.l10n.fourthDegree;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrollable contents of the page
        Positioned.fill(
          top: 20,
          child: ListView(
            children: [
              // The title
              pageTitleWidget,

              // Data input
              const DataInput(),

              // The results
              const PolynomialResults(),
            ],
          ),
        ),

        // "Go back" button
        const Positioned(
          top: 20,
          left: 20,
          child: _GoBackButton(),
        ),
      ],
    );
  }
}

/// A widget containing the title of the page.
class _PageTitle extends StatelessWidget {
  /// The title of the page.
  final String pageTitle;
  const _PageTitle({
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: PolynomialLogo(
            size: 50,
          ),
        ),
        Text(
          pageTitle,
          style: const TextStyle(fontSize: 26, color: Colors.blueGrey),
        ),
      ],
    );
  }
}

/// This button simply goes back to the previous page.
class _GoBackButton extends StatelessWidget {
  const _GoBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
