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
    return ListenableBuilder(
      listenable: context.otherState,
      builder: (context, _) {
        final result = context.otherState.state.results;

        if (result != null && result is ComplexResultWrapper) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
            ),
            child: _Results(
              abs: result.abs,
              conjugate: result.conjugate,
              phase: result.phase,
              polarComplex: result.polarComplex,
              reciprocal: result.reciprocal,
              sqrt: result.sqrt,
            ),
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
    final propertiesWidget = FocusTraversalGroup(
      child: Column(
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
      ),
    );

    // Polar coordinates
    final coordinatesWidget = FocusTraversalGroup(
      child: Column(
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
      ),
    );

    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.spaceAround,
      children: [
        SizedBox(
          width: complexNumbersPageColumnWidth,
          child: propertiesWidget,
        ),
        SizedBox(
          width: complexNumbersPageColumnWidth,
          child: coordinatesWidget,
        ),
      ],
    );
  }
}
