import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_output.dart';
import 'package:equations_solver/routes/polynomial_page/utils/complex_result_card.dart';
import 'package:equations_solver/routes/system_page/utils/double_result_card.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget shows the matrix analysis results produced by an [OtherBloc].
class MatrixAnalyzerResults extends StatelessWidget {
  /// Creates a [MatrixAnalyzerResults] widget.
  const MatrixAnalyzerResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        // Separator line
        SizedBox(
          height: 80,
        ),

        // Showing the analysis results
        _SystemSolutions(),

        // Additional spacing
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

class _SystemSolutions extends StatelessWidget {
  /// Creates a [_SystemSolutions] widget.
  const _SystemSolutions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherBloc, OtherState>(
      builder: (context, state) {
        if (state is AnalyzedMatrix) {
          return _Results(
            transpose: state.transpose,
            cofactorMatrix: state.cofactorMatrix,
            inverse: state.inverse,
            trace: state.trace,
            rank: state.rank,
            characteristicPolynomial: state.characteristicPolynomial,
            eigenvalues: state.eigenvalues,
            determinant: state.determinant,
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
  /// The transposed matrix.
  final RealMatrix transpose;

  /// The cofactor matrix.
  final RealMatrix cofactorMatrix;

  /// The inverse matrix.
  final RealMatrix inverse;

  /// The trace of the matrix.
  final double trace;

  /// The rank of the matrix.
  final int rank;

  /// The characteristic polynomial of the matrix.
  final Algebraic characteristicPolynomial;

  /// The eigenvalues of the matrix.
  final List<Complex> eigenvalues;

  /// The determinant of the matrix.
  final double determinant;

  /// Creates a [_Results] widget.
  const _Results({
    required this.transpose,
    required this.cofactorMatrix,
    required this.inverse,
    required this.trace,
    required this.rank,
    required this.characteristicPolynomial,
    required this.eigenvalues,
    required this.determinant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Properties
        SectionTitle(
          pageTitle: context.l10n.properties,
          icon: const SquareMatrix(),
        ),

        DoubleResultCard(
          value: rank * 1.0,
          leading: '${context.l10n.rank}: ',
        ),

        DoubleResultCard(
          value: trace,
          leading: '${context.l10n.trace}: ',
        ),

        DoubleResultCard(
          value: determinant,
          leading: '${context.l10n.determinant}: ',
        ),

        // Eigenvalues
        Padding(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: SectionTitle(
            pageTitle: context.l10n.eigenvalues,
            icon: const SquareMatrix(),
          ),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: eigenvalues.length,
          itemBuilder: (context, index) => ComplexResultCard(
            value: eigenvalues[index],
            leading: 'x$index = ',
          ),
        ),

        // Transpose
        Padding(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: SectionTitle(
            pageTitle: context.l10n.matrices,
            icon: const SquareMatrix(),
          ),
        ),

        // Spacing
        const SizedBox(
          height: 20,
        ),

        MatrixOutput(
          matrix: transpose,
          description: context.l10n.transpose,
        ),

        // Spacing
        const SizedBox(
          height: 20,
        ),

        MatrixOutput(
          matrix: inverse,
          description: context.l10n.inverse,
        ),

        // Spacing
        const SizedBox(
          height: 20,
        ),

        MatrixOutput(
          matrix: cofactorMatrix,
          description: context.l10n.cofactor,
        ),
      ],
    );
  }
}
