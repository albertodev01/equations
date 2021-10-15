import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This is a top-level function because it has to be passed to the [compute]
/// method for the concurrent analysis of the matrix.
AnalyzedMatrix _useMatrixAnalyzer(MatrixAnalyze event) {
  final analyzer = MatrixDataAnalyzer(
    flatMatrix: event.matrix,
    size: event.size,
  );

  return analyzer.process();
}

/// This bloc handles the contents of a [OtherPage] widget by analyzing matrices
/// or polynomials and returning various properties.
class OtherBloc extends Bloc<OtherEvent, OtherState> {
  /// Initializes an [OtherBloc] with [OtherNone]
  OtherBloc() : super(const OtherNone()) {
    on<MatrixAnalyze>(_onMatrixAnalyze);
    on<ComplexNumberAnalyze>(_onComplexNumberAnalyze);
    on<OtherClean>(_onOtherClean);
  }

  Future<void> _onMatrixAnalyze(
    MatrixAnalyze event,
    Emitter<OtherState> emit,
  ) async {
    emit(const OtherLoading());

    try {
      // Analyzing the matrix.
      final state = await compute<MatrixAnalyze, AnalyzedMatrix>(
        _useMatrixAnalyzer,
        event,
      );

      // Adding some time to make sure that the user can see the loading indicator.
      await Future.delayed(const Duration(milliseconds: 250));

      // Returning data
      emit(state);
    } catch (_) {
      emit(const OtherError());
    }
  }

  Future<void> _onComplexNumberAnalyze(
    ComplexNumberAnalyze event,
    Emitter<OtherState> emit,
  ) async {
    emit(const OtherLoading());

    try {
      // Analyzing the matrix.
      final state = ComplexNumberAnalyzer(
        realPart: event.realPart,
        imaginaryPart: event.imaginaryPart,
      ).process();

      // Returning data
      emit(state);
    } catch (_) {
      emit(const OtherError());
    }
  }

  Future<void> _onOtherClean(_, Emitter<OtherState> emit) async {
    emit(const OtherNone());
  }
}
