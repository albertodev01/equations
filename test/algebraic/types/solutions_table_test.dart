import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

final class SolutionsCase {
  new(
    this.equation,
    this.solutions, {
    this.precision = 1.0e-10,
    double? genericPrecision,
  }) : genericPrecision = genericPrecision ?? precision;

  final Algebraic equation;
  final List<Complex> solutions;
  final double precision;
  final double genericPrecision;
}

Algebraic real(List<double> coefficients) => Algebraic.fromReal(coefficients);
Algebraic complex(List<Complex> coefficients) => Algebraic.from(coefficients);
List<Complex> nthRootsOf(double value, int n) {
  final r = pow(value.abs(), 1 / n).toDouble();
  final offset = value < 0 ? pi / n : 0.0;

  return List<Complex>.generate(
    n,
    (k) => Complex.fromPolar(r: r, theta: offset + 2 * pi * k / n),
  );
}

final cases = <SolutionsCase>[
  // Linear
  SolutionsCase(real([2, 4]), const [Complex.fromReal(-2)]),
  SolutionsCase(real([1, 0]), const [Complex.zero()]),
  SolutionsCase(real([-3, 1]), const [Complex.fromReal(1 / 3)]),
  SolutionsCase(real([1e-20, -1e-20]), const [Complex.fromReal(1)]),
  SolutionsCase(real([1e20, 1]), const [Complex.fromReal(-1e-20)]),
  // (1 + i)x + 2 = 0, so x = -2 / (1 + i) = -1 + i
  SolutionsCase(complex(const [Complex(1, 1), Complex.fromReal(2)]), const [
    Complex(-1, 1),
  ]),
  // ix + 1 = 0, so x = i
  SolutionsCase(complex(const [Complex.i(), Complex.fromReal(1)]), const [
    Complex.i(),
  ]),

  // Quadratic

  // (x - 2)(x - 3)
  SolutionsCase(real([1, -5, 6]), const [
    Complex.fromReal(2),
    Complex.fromReal(3),
  ]),
  // x^2 = 0
  SolutionsCase(real([1, 0, 0]), const [Complex.zero(), Complex.zero()]),
  // (x - 1)^2
  SolutionsCase(real([1, -2, 1]), const [
    Complex.fromReal(1),
    Complex.fromReal(1),
  ], genericPrecision: 1e-7),
  // x^2 + 1
  SolutionsCase(real([1, 0, 1]), const [Complex.i(), Complex(0, -1)]),
  // x^2 - 2
  SolutionsCase(real([1, 0, -2]), const [
    Complex.fromReal(sqrt2),
    Complex.fromReal(-sqrt2),
  ]),
  // x(x + 2)
  SolutionsCase(real([1, 2, 0]), const [
    Complex.zero(),
    Complex.fromReal(-2),
  ]),
  // -2x^2 + 8 = -2(x - 2)(x + 2)
  SolutionsCase(real([-2, 0, 8]), const [
    Complex.fromReal(2),
    Complex.fromReal(-2),
  ]),
  // x^2 + 2x + 5, with roots -1 +/- 2i
  SolutionsCase(real([1, 2, 5]), const [Complex(-1, 2), Complex(-1, -2)]),
  // Catastrophic cancellation: the roots are about -1e-8 and -1e8
  SolutionsCase(real([1, 1e8, 1]), const [
    Complex.fromReal(-1e-8),
    Complex.fromReal(-100000000),
  ]),
  // Same as above, with the opposite sign of b
  SolutionsCase(real([1, -1e8, 1]), const [
    Complex.fromReal(1e-8),
    Complex.fromReal(100000000),
  ]),
  // Tiny coefficients: 1e-30 * (x - 1)(x - 2)
  SolutionsCase(real([1e-30, -3e-30, 2e-30]), const [
    Complex.fromReal(1),
    Complex.fromReal(2),
  ]),
  // (x - i)(x + 2i) = x^2 + ix + 2
  SolutionsCase(
    complex(const [Complex.fromReal(1), Complex.i(), Complex.fromReal(2)]),
    const [Complex.i(), Complex(0, -2)],
  ),
  // ix^2 + 1, so x^2 = i and x = +/- (1 + i) / sqrt(2)
  SolutionsCase(
    complex(const [Complex.i(), Complex.zero(), Complex.fromReal(1)]),
    const [Complex(sqrt1_2, sqrt1_2), Complex(-sqrt1_2, -sqrt1_2)],
  ),
  // (x - (1 + i))^2 = x^2 - (2 + 2i)x + 2i
  SolutionsCase(
    complex(const [Complex.fromReal(1), Complex(-2, -2), Complex(0, 2)]),
    const [Complex(1, 1), Complex(1, 1)],
    genericPrecision: 1e-7,
  ),

  // Cubic

  // (x - 1)(x - 2)(x - 3)
  SolutionsCase(real([1, -6, 11, -6]), const [
    Complex.fromReal(1),
    Complex.fromReal(2),
    Complex.fromReal(3),
  ]),
  // x^3 = 0
  SolutionsCase(real([1, 0, 0, 0]), const [
    Complex.zero(),
    Complex.zero(),
    Complex.zero(),
  ], genericPrecision: 1e-9),
  // (x - 1)^3
  SolutionsCase(real([1, -3, 3, -1]), const [
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(1),
  ], genericPrecision: 1e-4),
  // (x - 1)^2 (x + 2)
  SolutionsCase(real([1, 0, -3, 2]), const [
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(-2),
  ], genericPrecision: 1e-7),
  // x^3 - 1
  SolutionsCase(real([1, 0, 0, -1]), nthRootsOf(1, 3)),
  // x^3 + 8
  SolutionsCase(real([1, 0, 0, 8]), nthRootsOf(-8, 3)),
  // x(x^2 + 1)
  SolutionsCase(real([1, 0, 1, 0]), const [
    Complex.zero(),
    Complex.i(),
    Complex(0, -1),
  ]),
  // 2x^2(x - 2)
  SolutionsCase(real([2, -4, 0, 0]), const [
    Complex.zero(),
    Complex.zero(),
    Complex.fromReal(2),
  ], genericPrecision: 1e-7),
  // -(x + 1)(x - 4)(x - 5)
  SolutionsCase(real([-1, 8, -11, -20]), const [
    Complex.fromReal(-1),
    Complex.fromReal(4),
    Complex.fromReal(5),
  ]),
  // (x - 2)(x^2 + 1)
  SolutionsCase(real([1, -2, 1, -2]), const [
    Complex.fromReal(2),
    Complex.i(),
    Complex(0, -1),
  ]),
  // Widely spread roots: (x - 0.001)(x - 1)(x - 1000)
  SolutionsCase(real([1, -1001.001, 1001.001, -1]), const [
    Complex.fromReal(0.001),
    Complex.fromReal(1),
    Complex.fromReal(1000),
  ]),
  // (x - i)^3 = x^3 - 3ix^2 - 3x + i
  SolutionsCase(
    complex(const [
      Complex.fromReal(1),
      Complex(0, -3),
      Complex.fromReal(-3),
      Complex.i(),
    ]),
    const [Complex.i(), Complex.i(), Complex.i()],
    genericPrecision: 1e-4,
  ),
  // (x - 1)(x - i)(x + 1 + i) = x^3 - ix - 1 + i
  SolutionsCase(
    complex(const [
      Complex.fromReal(1),
      Complex.zero(),
      Complex(0, -1),
      Complex(-1, 1),
    ]),
    const [Complex.fromReal(1), Complex.i(), Complex(-1, -1)],
  ),
  // ix^3 + i = i(x^3 + 1)
  SolutionsCase(
    complex(const [
      Complex.i(),
      Complex.zero(),
      Complex.zero(),
      Complex.i(),
    ]),
    nthRootsOf(-1, 3),
  ),

  // Quartic

  // (x - 1)(x - 2)(x - 3)(x - 4)
  SolutionsCase(real([1, -10, 35, -50, 24]), const [
    Complex.fromReal(1),
    Complex.fromReal(2),
    Complex.fromReal(3),
    Complex.fromReal(4),
  ]),
  // x^4 = 0
  SolutionsCase(real([1, 0, 0, 0, 0]), const [
    Complex.zero(),
    Complex.zero(),
    Complex.zero(),
    Complex.zero(),
  ], genericPrecision: 1e-9),
  // (x - 1)^4
  SolutionsCase(real([1, -4, 6, -4, 1]), const [
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(1),
  ], genericPrecision: 1e-3),
  // x^4 - 1
  SolutionsCase(real([1, 0, 0, 0, -1]), nthRootsOf(1, 4)),
  // x^4 + 1
  SolutionsCase(real([1, 0, 0, 0, 1]), nthRootsOf(-1, 4)),
  // Biquadratic: (x^2 - 1)(x^2 - 4)
  SolutionsCase(real([1, 0, -5, 0, 4]), const [
    Complex.fromReal(1),
    Complex.fromReal(-1),
    Complex.fromReal(2),
    Complex.fromReal(-2),
  ]),
  // Biquadratic: (x^2 - 2)(x^2 + 3)
  SolutionsCase(real([1, 0, 1, 0, -6]), [
    const Complex.fromReal(sqrt2),
    const Complex.fromReal(-sqrt2),
    Complex(0, sqrt(3)),
    Complex(0, -sqrt(3)),
  ]),
  // (x^2 + 1)^2
  SolutionsCase(real([1, 0, 2, 0, 1]), const [
    Complex.i(),
    Complex.i(),
    Complex(0, -1),
    Complex(0, -1),
  ], genericPrecision: 1e-7),
  // (x - 1)^2 (x - 2)^2
  SolutionsCase(real([1, -6, 13, -12, 4]), const [
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(2),
    Complex.fromReal(2),
  ], genericPrecision: 1e-7),
  // x^3(x + 1)
  SolutionsCase(real([1, 1, 0, 0, 0]), const [
    Complex.zero(),
    Complex.zero(),
    Complex.zero(),
    Complex.fromReal(-1),
  ], genericPrecision: 1e-4),
  // x(x^3 - 1)
  SolutionsCase(real([1, 0, 0, -1, 0]), [
    const Complex.zero(),
    ...nthRootsOf(1, 3),
  ]),
  // (x - 1)^3 (x + 3), which is not biquadratic after the shift x = y + 1/2
  SolutionsCase(real([1, 0, -6, 8, -3]), const [
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(-3),
  ], genericPrecision: 1e-4),
  // (x - 1)(x + 1)(x - 2)(x + 3), with a non-unit leading coefficient: 3(...)
  SolutionsCase(real([3, 3, -21, -3, 18]), const [
    Complex.fromReal(1),
    Complex.fromReal(-1),
    Complex.fromReal(2),
    Complex.fromReal(-3),
  ]),
  // (x^2 + 2x + 2)(x^2 - 2x + 5), with roots -1 +/- i and 1 +/- 2i
  SolutionsCase(real([1, 0, 3, 6, 10]), const [
    Complex(-1, 1),
    Complex(-1, -1),
    Complex(1, 2),
    Complex(1, -2),
  ]),
  // (x - i)(x + i)(x - 2i)(x + 2i) = x^4 + 5x^2 + 4
  SolutionsCase(real([1, 0, 5, 0, 4]), const [
    Complex.i(),
    Complex(0, -1),
    Complex(0, 2),
    Complex(0, -2),
  ]),
  // (x - i)^2 (x - 1)^2 = x^4 - (2 + 2i)x^3 + 4ix^2 + (2 - 2i)x - 1
  SolutionsCase(
    complex(const [
      Complex.fromReal(1),
      Complex(-2, -2),
      Complex(0, 4),
      Complex(2, -2),
      Complex.fromReal(-1),
    ]),
    const [Complex.i(), Complex.i(), Complex.fromReal(1), Complex.fromReal(1)],
    precision: 1e-7,
    genericPrecision: 1e-7,
  ),
  // ix^4 - i = i(x^4 - 1)
  SolutionsCase(
    complex(const [
      Complex.i(),
      Complex.zero(),
      Complex.zero(),
      Complex.zero(),
      Complex(0, -1),
    ]),
    nthRootsOf(1, 4),
  ),

  // Degree 5 or higher (GenericAlgebraic)

  // (x - 1)(x - 2)(x - 3)(x - 4)(x - 5)
  SolutionsCase(real([1, -15, 85, -225, 274, -120]), const [
    Complex.fromReal(1),
    Complex.fromReal(2),
    Complex.fromReal(3),
    Complex.fromReal(4),
    Complex.fromReal(5),
  ], precision: 1e-9),
  // x^5 - 1
  SolutionsCase(real([1, 0, 0, 0, 0, -1]), nthRootsOf(1, 5)),
  // x^5 + 32
  SolutionsCase(real([1, 0, 0, 0, 0, 32]), nthRootsOf(-32, 5)),
  // x^6 - 1
  SolutionsCase(real([1, 0, 0, 0, 0, 0, -1]), nthRootsOf(1, 6)),
  // x(x^4 + 1)
  SolutionsCase(real([1, 0, 0, 0, 1, 0]), [
    const Complex.zero(),
    ...nthRootsOf(-1, 4),
  ]),
  // x(x^6 - 1)
  SolutionsCase(real([1, 0, 0, 0, 0, 0, -1, 0]), [
    const Complex.zero(),
    ...nthRootsOf(1, 6),
  ]),
  // (x^4 - 1)(x - 2)
  SolutionsCase(real([1, -2, 0, 0, -1, 2]), [
    const Complex.fromReal(2),
    ...nthRootsOf(1, 4),
  ]),
  // (x^2 + 1)(x^2 + 4)(x - 3)
  SolutionsCase(real([1, -3, 5, -15, 4, -12]), const [
    Complex.fromReal(3),
    Complex.i(),
    Complex(0, -1),
    Complex(0, 2),
    Complex(0, -2),
  ]),
  // 2(x^8 - 1)
  SolutionsCase(real([2, 0, 0, 0, 0, 0, 0, 0, -2]), nthRootsOf(1, 8)),
  // x^10 + 1
  SolutionsCase(real([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]), nthRootsOf(-1, 10)),
  // (x - 1)^2 (x + 1)^3 = x^5 + x^4 - 2x^3 - 2x^2 + x + 1
  SolutionsCase(real([1, 1, -2, -2, 1, 1]), const [
    Complex.fromReal(1),
    Complex.fromReal(1),
    Complex.fromReal(-1),
    Complex.fromReal(-1),
    Complex.fromReal(-1),
  ], precision: 1e-4),
  // ix^5 - i = i(x^5 - 1)
  SolutionsCase(
    complex(const [
      Complex.i(),
      Complex.zero(),
      Complex.zero(),
      Complex.zero(),
      Complex.zero(),
      Complex(0, -1),
    ]),
    nthRootsOf(1, 5),
  ),
  // (x - i)(x + i)(x - 1)(x + 1)(x - 1 - i) = (x^4 - 1)(x - 1 - i)
  SolutionsCase(
    complex(const [
      Complex.fromReal(1),
      Complex(-1, -1),
      Complex.zero(),
      Complex.zero(),
      Complex.fromReal(-1),
      Complex(1, 1),
    ]),
    [const Complex(1, 1), ...nthRootsOf(1, 4)],
  ),
];

String? matchRoots(
  List<Complex> actual,
  List<Complex> expected,
  double precision,
) {
  if (actual.length != expected.length) {
    return 'expected ${expected.length} roots, found ${actual.length}';
  }

  final unused = List<Complex>.of(actual);
  final unmatched = <Complex>[];

  for (final root in expected) {
    final tolerance = precision * max(1.0, root.abs());
    final distances = unused.map((r) => (r - root).abs()).toList();
    final closest = distances.indexed.fold<(int, double)?>(
      null,
      (best, e) => best == null || e.$2 < best.$2 ? e : best,
    );

    if (closest == null || closest.$2 > tolerance) {
      unmatched.add(root);
    } else {
      unused.removeAt(closest.$1);
    }
  }

  return unmatched.isEmpty
      ? null
      : 'no match for $unmatched (precision $precision)';
}

double termsSize(Algebraic equation, Complex x) {
  final absX = x.abs();
  return equation.coefficients.fold<double>(
    0,
    (sum, c) => sum * absX + c.abs(),
  );
}

void main() {
  group('Solutions table', () {
    for (final c in cases) {
      group('${c.equation}', () {
        test('solutions() returns the expected roots', () {
          final solutions = c.equation.solutions();

          expect(
            matchRoots(solutions, c.solutions, c.precision),
            isNull,
            reason: 'Computed roots: $solutions',
          );
        });

        test('The expected roots are actually roots', () {
          // This guards against a wrong entry in the table
          for (final root in c.solutions) {
            final residual = c.equation.evaluateOn(root).abs();
            expect(
              residual,
              lessThanOrEqualTo(1e-12 * termsSize(c.equation, root)),
              reason: 'P($root) = ${c.equation.evaluateOn(root)}',
            );
          }
        });

        test("Vieta's formulas hold for the computed roots", () {
          final solutions = c.equation.solutions();
          final coefficients = c.equation.coefficients;
          final n = coefficients.length - 1;
          final leading = coefficients.first;

          // Sum of the roots: -a_1 / a_0
          final sum = solutions.fold(
            const Complex.zero(),
            (s, r) => s + r,
          );
          final expectedSum = -coefficients[1] / leading;
          expect(
            (sum - expectedSum).abs(),
            lessThanOrEqualTo(c.precision * max(1.0, expectedSum.abs()) * n),
          );

          // Product of the roots: (-1)^n * a_n / a_0
          final product = solutions.fold(
            const Complex.fromReal(1),
            (p, r) => p * r,
          );
          final sign = n.isEven ? 1.0 : -1.0;
          final expectedProduct =
              Complex.fromReal(sign) * coefficients.last / leading;
          final scale = solutions.fold<double>(
            1,
            (s, r) => s * max(1, r.abs()),
          );
          expect(
            (product - expectedProduct).abs(),
            lessThanOrEqualTo(c.precision * scale * n),
          );
        });

        if (c.equation is! GenericAlgebraic) {
          test('GenericAlgebraic finds the same roots', () {
            final solutions = GenericAlgebraic(
              coefficients: c.equation.coefficients,
            ).solutions();

            expect(
              matchRoots(solutions, c.solutions, c.genericPrecision),
              isNull,
              reason: 'Computed roots: $solutions',
            );
          });
        }
      });
    }
  });
}
