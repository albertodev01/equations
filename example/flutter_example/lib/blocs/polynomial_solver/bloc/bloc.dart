import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the contents of a [PolynomialBody] widget by processing
/// the coefficients (received as raw strings) and solving polynomial equations.
class PolynomialBloc extends Bloc<PolynomialEvent, PolynomialState> {
  /// The type of polynomial this bloc has to solve.
  final PolynomialType polynomialType;

  /// Initializes a [PolynomialBloc] with [PolynomialNone]
  PolynomialBloc(this.polynomialType) : super(const PolynomialNone());

  @override
  Stream<PolynomialState> mapEventToState(PolynomialEvent event) async* {
    if (event is PolynomialSolve) {
      yield* _polynomialSolveHandler(event);
    }

    if (event is PolynomialClean) {
      yield* _polynomialCleanHandler(event);
    }
  }

  List<Complex> _parseCoefficients(List<String> rawInput) {
    // Fractions are accepted so this method throws only if the given string is
    // NOT a number or a string
    return rawInput.map((coefficient) {
      final fraction = Fraction.fromString(coefficient);
      return Complex.fromRealFraction(fraction);
    }).toList(growable: false);
  }

  Stream<PolynomialState> _polynomialSolveHandler(PolynomialSolve evt) async* {
    try {
      // Parsing coefficients
      final params = _parseCoefficients(evt.coefficients);
      final solver = Algebraic.from(params);

      // Determines whether the given equation is valid or not
      if (solver.isValid) {
        yield PolynomialRoots(
          roots: solver.solutions(),
          discriminant: solver.discriminant(),
          algebraic: solver,
        );
      } else {
        yield const PolynomialError();
      }
    } on Exception {
      yield const PolynomialError();
    }
  }

  Stream<PolynomialState> _polynomialCleanHandler(PolynomialClean evt) async* {
    yield const PolynomialNone();
  }
}
