import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyze_results.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyzer_input.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// This widget analyzes a matrix and computes various properties such as rank,
/// eigenvalues, inverse and much more.
class MatrixOtherBody extends StatelessWidget {
  /// Creates a [MatrixOtherBody] widget.
  const MatrixOtherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // Scrollable contents of the page
        Positioned.fill(
          child: _PageBody(),
        ),

        // "Go back" button
        Positioned(
          top: 20,
          left: 20,
          child: GoBackButton(),
        ),
      ],
    );
  }
}

/// The actual contents of the [MatrixOtherBody] widget.
class _PageBody extends StatefulWidget {
  /// Creates a [_PageBody] widget.
  const _PageBody();

  @override
  State<_PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<_PageBody> {
  /// Manually caching the page title.
  late final Widget pageTitleWidget = PageTitle(
    pageTitle: context.l10n.matrices,
    pageLogo: const OtherMatrix(
      size: 50,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        pageTitleWidget,

        // Data input
        const MatrixAnalyzerInput(),

        // Results
        const MatrixAnalyzerResults(),
      ],
    );
  }
}
