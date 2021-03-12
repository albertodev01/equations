import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc...
class PolynomialBloc extends Bloc<PolynomialEvent, PolynomialState> {
  final PolynomialType polynomialType;
  PolynomialBloc({required this.polynomialType})
      : super(const PolynomialNone());

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
    return rawInput.map((coefficient) {
      final fraction = Fraction.fromString(coefficient);
      return Complex.fromRealFraction(fraction);
    }).toList(growable: false);
  }

  Stream<PolynomialState> _polynomialSolveHandler(
      PolynomialSolve event) async* {
    try {
      final params = _parseCoefficients(event.coefficients);
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

  Stream<PolynomialState> _polynomialCleanHandler(
      PolynomialClean event) async* {
    yield const PolynomialNone();
  }
}
