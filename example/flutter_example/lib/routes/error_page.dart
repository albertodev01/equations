import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// The error page is shown when the user tries to open a route with a wrong
/// deep link. This generally happens when the app is running on the web and
/// the user enters a wrong URL.
class ErrorPage extends StatelessWidget {
  /// Creates a [ErrorPage] widget.
  const ErrorPage({
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
                  // The error image at the top
                  UrlError(
                    size: 85,
                  ),

                  // The error message
                  _ErrorText(),
                ],
              ),
            ),
          ),
        ],
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
