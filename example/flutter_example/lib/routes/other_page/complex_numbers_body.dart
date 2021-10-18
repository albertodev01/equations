import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_analyzer_input.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_analyzer_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// This widget analyzes a matrix and outputs various results about its rank,
/// determinant, eigenvalues and much more.
class ComplexNumberOtherBody extends StatelessWidget {
  /// Creates a [ComplexNumberOtherBody] widget.
  const ComplexNumberOtherBody({Key? key}) : super(key: key);

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

/// The actual contents of the [ComplexNumberOtherBody] widget.
class _PageBody extends StatefulWidget {
  /// Creates a [_PageBody] widget.
  const _PageBody({Key? key}) : super(key: key);

  @override
  State<_PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<_PageBody> {
  /// Manually caching the page title.
  late final Widget pageTitleWidget = PageTitle(
    pageTitle: context.l10n.complex_numbers,
    pageLogo: const ToolsComplexNumbers(),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        pageTitleWidget,

        // Data input
        const ComplexAnalyzerInput(),

        // Results
        const ComplexNumberAnalyzerResult(),
      ],
    );
  }
}
