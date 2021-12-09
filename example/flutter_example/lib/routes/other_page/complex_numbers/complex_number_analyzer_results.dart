import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/complex_result_card.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget shows the complex number analysis results produced by an
/// [OtherBloc].
class ComplexNumberAnalyzerResult extends StatelessWidget {
  /// Creates a [ComplexNumberAnalyzerResult] widget.
  const ComplexNumberAnalyzerResult({Key? key}) : super(key: key);

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

class _ComplexAnalysis extends StatelessWidget {
  /// Creates a [_ComplexAnalysis] widget.
  const _ComplexAnalysis();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherBloc, OtherState>(
      builder: (context, state) {
        if (state is AnalyzedComplexNumber) {
          return _Results(
            abs: state.abs,
            conjugate: state.conjugate,
            phase: state.phase,
            polarComplex: state.polarComplex,
            reciprocal: state.reciprocal,
            sqrt: state.sqrt,
          );
        }

        if (state is OtherLoading) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Loading indicator
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 20,
                ),
                child: CircularProgressIndicator(),
              ),

              // Waiting text
              Text(context.l10n.wait_a_moment),
            ],
          );
        }

        return const NoResults();
      },
    );
  }
}

class _Results extends StatelessWidget {
  /// The polar representation of the complex number.
  final PolarComplex polarComplex;

  /// The complex conjugate.
  final Complex conjugate;

  /// The complex reciprocal.
  final Complex reciprocal;

  /// The modulus/aboslute value.
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Properties
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

        // Eigenvalues
        Padding(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: SectionTitle(
            pageTitle: context.l10n.polar_coordinates,
            icon: const HalfRightAngle(),
          ),
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
  }
}
