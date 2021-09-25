import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the contents of a [PolynomialBody] widget by processing
/// the coefficients (received as raw strings) and solving polynomial equations.
class PolynomialBloc extends Bloc<PolynomialEvent, PolynomialState> {
  /// The type of polynomial this bloc has to solve.
  final PolynomialType polynomialType;

  /// This is required to parse the coefficients received from the user as 'raw'
  /// strings.
  final _parser = const ExpressionParser();

  /// Initializes a [PolynomialBloc] with [PolynomialNone].
  PolynomialBloc(this.polynomialType) : super(const PolynomialNone()) {
    on<PolynomialSolve>(_onPolySolve);
    on<PolynomialClean>(_onPolyClean);
  }

  void _onPolySolve(PolynomialSolve evt, Emitter<PolynomialState> emit) {
    try {
      // Parsing coefficients
      final params = _parseCoefficients(evt.coefficients);
      final solver = Algebraic.from(params);

      // Determines whether the given equation is valid or not
      emit(
        PolynomialRoots(
          roots: solver.solutions(),
          discriminant: solver.discriminant(),
          algebraic: solver,
        ),
      );
    } on Exception {
      emit(const PolynomialError());
    }
  }

  void _onPolyClean(_, Emitter<PolynomialState> emit) {
    emit(const PolynomialNone());
  }

  List<Complex> _parseCoefficients(List<String> rawInput) {
    if (rawInput.length != _coefficientsListLength) {
      throw const FormatException("'The coefficients list length doesn't match "
          'the coefficients number expected from the given degree.');
    }

    // Fractions are accepted so this method throws only if the given string is
    // NOT a number or a string
    return rawInput.map<Complex>((value) {
      if (!value.isNumericalExpression) {
        throw FormatException('The "$value" input is not a valid number.');
      }

      return Complex.fromReal(_parser.evaluate(value));
    }).toList();
  }

  int get _coefficientsListLength {
    switch (polynomialType) {
      case PolynomialType.linear:
        return 2;
      case PolynomialType.quadratic:
        return 3;
      case PolynomialType.cubic:
        return 4;
      case PolynomialType.quartic:
        return 5;
    }
  }
}
