import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/complex_result_wrapper.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// This widget shows the complex number analysis results produced by an
/// [OtherState] class.
class ComplexNumberAnalyzerResult extends StatelessWidget {
  /// Creates a [ComplexNumberAnalyzerResult] widget.
  const ComplexNumberAnalyzerResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        // Separator line
        SizedBox(
          height: 80,
        ),

        // Showing the analysis results
        _ComplexAnalysis(),

        // Additional spacing
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

/// Either prints nothing or the analysis results.
class _ComplexAnalysis extends StatelessWidget {
  /// Creates a [_ComplexAnalysis] widget.
  const _ComplexAnalysis();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.otherState,
      builder: (context, _) {
        final result = context.otherState.state.results;

        if (result != null && result is ComplexResultWrapper) {
          return _Results(
            abs: result.abs,
            conjugate: result.conjugate,
            phase: result.phase,
            polarComplex: result.polarComplex,
            reciprocal: result.reciprocal,
            sqrt: result.sqrt,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// The complex number analysis results.
class _Results extends StatelessWidget {
  /// The polar representation of the complex number.
  final PolarComplex polarComplex;

  /// The complex conjugate.
  final Complex conjugate;

  /// The complex reciprocal.
  final Complex reciprocal;

  /// The modulus/absolute value.
  final double abs;

  /// The square root of the complex number.
  final Complex sqrt;

  /// The phase.
  final double phase;

  /// Creates an [_Results] object..
  const _Results({
    super.key,
    required this.polarComplex,
    required this.conjugate,
    required this.reciprocal,
    required this.abs,
    required this.sqrt,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    // Properties
    final propertiesWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionTitle(
          pageTitle: context.l10n.properties,
          icon: const SquareRoot(),
        ),
        RealResultCard(
          value: abs,
          leading: '${context.l10n.abs}: ',
        ),
        RealResultCard(
          value: phase,
          leading: '${context.l10n.phase}: ',
        ),
        ComplexResultCard(
          value: sqrt,
          leading: '${context.l10n.sqrt}: ',
        ),
        ComplexResultCard(
          value: conjugate,
          leading: '${context.l10n.conjugate}: ',
        ),
        ComplexResultCard(
          value: reciprocal,
          leading: '${context.l10n.reciprocal}: ',
        ),
      ],
    );

    // Polar coordinates
    final coordinatesWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionTitle(
          pageTitle: context.l10n.polar_coordinates,
          icon: const HalfRightAngle(),
        ),
        RealResultCard(
          value: polarComplex.r,
          leading: '${context.l10n.length}: ',
        ),
        RealResultCard(
          value: polarComplex.phiDegrees,
          leading: '${context.l10n.angle_deg}: ',
        ),
        RealResultCard(
          value: polarComplex.phiRadians,
          leading: '${context.l10n.angle_rad}: ',
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, dimensions) {
        // For mobile devices - all in a column
        if (dimensions.maxWidth <= matricesPageDoubleColumn) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Numerical properties
              propertiesWidget,

              // Some spacing
              const SizedBox(
                height: 80,
              ),

              // Polar coordinates
              coordinatesWidget,
            ],
          );
        }

        // For wider screens - splitting numerical results in two columns
        return Wrap(
          spacing: 80,
          runSpacing: 40,
          alignment: WrapAlignment.spaceAround,
          runAlignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: complexPageColumnWidth,
              child: propertiesWidget,
            ),
            SizedBox(
              width: complexPageColumnWidth,
              child: coordinatesWidget,
            ),
          ],
        );
      },
    );
  }
}
