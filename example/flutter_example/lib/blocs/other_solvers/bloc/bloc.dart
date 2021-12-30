import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the contents of a [OtherPage] widget by analyzing matrices
/// or complex numbers and returning various properties.
class OtherBloc extends Bloc<OtherEvent, OtherState> {
  /// Initializes an [OtherBloc] with [OtherNone].
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
      final state = MatrixDataAnalyzer(
        flatMatrix: event.matrix,
        size: event.size,
      ).process();

      // Returning data
      emit(state);
    } on Exception {
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
    } on Exception {
      emit(const OtherError());
    }
  }

  Future<void> _onOtherClean(_, Emitter<OtherState> emit) async {
    emit(const OtherNone());
  }
}
