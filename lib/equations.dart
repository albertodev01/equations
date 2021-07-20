library equations;

export 'package:fraction/fraction.dart';

export 'src/algebraic/algebraic.dart';
export 'src/algebraic/types/constant.dart';
export 'src/algebraic/types/cubic.dart';
export 'src/algebraic/types/laguerre.dart';
export 'src/algebraic/types/linear.dart';
export 'src/algebraic/types/quadratic.dart';
export 'src/algebraic/types/quartic.dart';
export 'src/algebraic/utils/algebraic_division.dart';
export 'src/algebraic/utils/horner_results.dart';
export 'src/algebraic/utils/polynomial_long_division.dart';
export 'src/algebraic/utils/sylvester_matrix.dart';

export 'src/interpolation/interpolation.dart';
export 'src/interpolation/types/linear_interpolation.dart';
export 'src/interpolation/types/newton_interpolation.dart';
export 'src/interpolation/types/polynomial_interpolation.dart';
export 'src/interpolation/utils/interpolation_node.dart';

export 'src/nonlinear/nonlinear.dart';
export 'src/nonlinear/types/bisection.dart';
export 'src/nonlinear/types/brent.dart';
export 'src/nonlinear/types/chords.dart';
export 'src/nonlinear/types/newton.dart';
export 'src/nonlinear/types/regula_falsi.dart';
export 'src/nonlinear/types/secant.dart';
export 'src/nonlinear/types/steffensen.dart';
export 'src/nonlinear/utils/integration.dart';
export 'src/nonlinear/utils/integration/midpoint_rule.dart';
export 'src/nonlinear/utils/integration/simpson_rule.dart';
export 'src/nonlinear/utils/integration/trapezoidal_rule.dart';
export 'src/nonlinear/utils/results/integral_results.dart';
export 'src/nonlinear/utils/results/results_nonlinear.dart';

export 'src/system/system.dart';
export 'src/system/types/cholesky.dart';
export 'src/system/types/gauss.dart';
export 'src/system/types/gauss_seidel.dart';
export 'src/system/types/jacobi.dart';
export 'src/system/types/lu.dart';
export 'src/system/types/sor.dart';
export 'src/system/utils/matrix.dart';
export 'src/system/utils/matrix/complex_matrix.dart';
export 'src/system/utils/matrix/real_matrix.dart';

export 'src/utils/complex/complex.dart';
export 'src/utils/complex/polar_complex.dart';
export 'src/utils/exceptions/exceptions.dart';
export 'src/utils/exceptions/types/algebraic_exception.dart';
export 'src/utils/exceptions/types/complex_exception.dart';
export 'src/utils/exceptions/types/matrix_exception.dart';
export 'src/utils/exceptions/types/nonlinear_exception.dart';
export 'src/utils/exceptions/types/parser_exception.dart';
export 'src/utils/exceptions/types/poly_long_division_exception.dart';
export 'src/utils/exceptions/types/system_solver_exception.dart';
export 'src/utils/expression_parser.dart';
