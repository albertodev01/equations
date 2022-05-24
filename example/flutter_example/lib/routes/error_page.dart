import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// The home page shows a series of cards representing the various solvers of
/// the app.
class ErrorPage extends StatelessWidget {
  /// Creates a [ErrorPage] widget.
  const ErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EquationScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              // The error image at the top
              UrlError(
                size: 100,
              ),

              // The error message
              _ErrorText(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: Text(
        context.l10n.url_error,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
