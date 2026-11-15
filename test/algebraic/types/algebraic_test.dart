import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('Algebraic', () {
    group('from constructor (Complex variant)', () {
      test('Constant', () {
        final equation = Algebraic.from([const Complex(1, 0)]);
        expect(equation, isA<Constant>());
      });

      test('Linear', () {
        final equation = Algebraic.from(const [Complex(1, 0), Complex(2, 0)]);
        expect(equation, isA<Linear>());

        expect(equation[0], const Complex(1, 0));
        expect(equation[1], const Complex(2, 0));
        expect(equation.coefficient(1), const Complex(1, 0));
        expect(equation.coefficient(0), const Complex(2, 0));
      });

      test('Quadratic', () {
        final equation = Algebraic.from(const [
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
        ]);

        expect(equation, isA<Quadratic>());
      });

      test('Cubic', () {
        final equation = Algebraic.from(const [
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
          Complex(4, 0),
        ]);
        expect(equation, isA<Cubic>());
      });

      test('Quartic', () {
        final equation = Algebraic.from(const [
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
          Complex(4, 0),
          Complex(5, 0),
        ]);

        expect(equation, isA<Quartic>());
      });

      test('Quintic (GenericAlgebraic)', () {
        final equation = Algebraic.from(const [
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
          Complex(4, 0),
          Complex(5, 0),
          Complex(6, 0),
        ]);

        expect(equation, isA<GenericAlgebraic>());
      });
    });

    // Tests with real numbers
    group('from constructor (Real variant)', () {
      test('Constant', () {
        final equation = Algebraic.fromReal([1]);
        expect(equation, isA<Constant>());
      });

      test('Linear', () {
        final equation = Algebraic.fromReal([1, 2]);
        expect(equation, isA<Linear>());
      });

      test('Quadratic', () {
        final equation = Algebraic.fromReal([1, 2, 3]);
        expect(equation, isA<Quadratic>());
      });

      test('Cubic', () {
        final equation = Algebraic.fromReal([1, 2, 3, 4]);
        expect(equation, isA<Cubic>());
      });

      test('Qartic', () {
        final equation = Algebraic.fromReal([1, 2, 3, 4, 5]);
        expect(equation, isA<Quartic>());
      });

      test('Quintic (GenericAlgebraic)', () {
        final equation = Algebraic.fromReal([1, 2, 3, 4, 5, 6]);
        expect(equation, isA<GenericAlgebraic>());
      });
    });

    group('Integral evaluation', () {
      test('Constant', () {
        final constant = Algebraic.from(const [Complex(2, -5)]);
        final integral = constant.evaluateIntegralOn(4, 5);

        expect(integral.real.round(), equals(2));
        expect(integral.imaginary.round(), equals(-5));
      });

      test('Linear', () {
        // Real polynomial test
        final realEq = Linear.realEquation(a: -6, b: 2);

        final realRes = realEq.evaluateIntegralOn(2, 1);
        expect(realRes.real, const MoreOrLessEquals(7, precision: 0));

        // Complex polynomial test
        final complexEq = Linear(a: const Complex(4, -3));

        final complexRes = complexEq.evaluateIntegralOn(0, 3);

        expect(complexRes.real, const MoreOrLessEquals(18, precision: 1.0e-1));
        expect(
          complexRes.imaginary,
          const MoreOrLessEquals(-13.5, precision: 1.0e-1),
        );
      });

      test('Quadratic', () {
        // Real polynomial test
        final realEq = Quadratic.realEquation(a: 2, c: -5);

        final realRes = realEq.evaluateIntegralOn(1, 3);

        expect(realRes.real, const MoreOrLessEquals(7.3, precision: 1.0e-1));

        // Complex polynomial test
        final complexEq = Quadratic(
          a: const Complex(3, -5),
          b: const Complex(1, 2),
          c: const Complex.fromImaginary(4),
        );

        final complexRes = complexEq.evaluateIntegralOn(-1, 5);

        expect(complexRes.real, const MoreOrLessEquals(138, precision: 1.0e-1));
        expect(
          complexRes.imaginary,
          const MoreOrLessEquals(-162, precision: 1.0e-1),
        );
      });

      test('Cubic', () {
        // Real polynomial test
        final realEq = Cubic.realEquation(c: 3, d: -5);

        final realRes = realEq.evaluateIntegralOn(1, 3);
        expect(realRes.real.round(), equals(22));

        // Complex polynomial test
        final complexEq = Cubic(
          a: const Complex(3, -5),
          b: const Complex(1, 2),
          c: const Complex.fromImaginary(4),
          d: const Complex.fromReal(4),
        );

        final complexRes = complexEq.evaluateIntegralOn(-1, 5);
        expect(complexRes.real, const MoreOrLessEquals(534, precision: 1.0e-1));
        expect(
          complexRes.imaginary,
          const MoreOrLessEquals(-648, precision: 1.0e-1),
        );
      });

      test('Quartic', () {
        // Real polynomial test
        final realEq = Quartic.realEquation(a: 3, b: -1, c: 4, d: 0.5, e: -2);

        final realRes = realEq.evaluateIntegralOn(2, -2);
        expect(realRes.real, const MoreOrLessEquals(-51.73, precision: 1.0e-2));

        // Complex polynomial test
        final complexEq = Quartic(
          a: const Complex.i(),
          b: const Complex(-3, 5),
          c: const Complex(4, 1),
          d: -const Complex.i(),
        );

        final complexRes = complexEq.evaluateIntegralOn(0.5, 1.2);
        expect(
          complexRes.real,
          const MoreOrLessEquals(0.629, precision: 1.0e-4),
        );
        expect(
          complexRes.imaginary,
          const MoreOrLessEquals(2.9446, precision: 1.0e-4),
        );
      });
    });

    group('Operators', () {
      // Tests with complex numbers
      group('Complex numbers', () {
        test('Sum of two polynomials', () {
          final complex1 = Algebraic.from(const [
            Complex(-3, 10),
            Complex.i(),
            Complex.fromImaginary(6),
          ]);
          final complex2 = Algebraic.fromReal([1, 5]);

          final sum = complex1 + complex2;
          final sumResult = Algebraic.from(const [
            Complex(-3, 10),
            Complex(1, 1),
            Complex(5, 6),
          ]);

          expect(sum, equals(sumResult));
          expect(sum, equals(complex2 + complex1));
          expect(sum, isA<Quadratic>());
        });

        test('Difference of two polynomials', () {
          final complex1 = Algebraic.from(const [
            Complex(-4, -7),
            Complex(2, 3),
            Complex.zero(),
          ]);
          final complex2 = Algebraic.from([
            const Complex(3, 6),
            -const Complex.i(),
            const Complex(7, -8),
            const Complex(1, -3),
            const Complex(5, 6),
          ]);

          final diff = complex1 - complex2;
          final diffResult = Algebraic.from([
            const Complex(-3, -6),
            const Complex.i(),
            const Complex(-11, 1),
            const Complex(1, 6),
            -const Complex(5, 6),
          ]);

          expect(diff, equals(diffResult));
          expect(complex2 - complex1, equals(-diffResult));
          expect(diffResult, isA<Quartic>());
        });

        test('Product of two polynomials', () {
          final complex1 = Algebraic.from([
            Complex.fromImaginaryFraction(Fraction(6, 2)),
            -const Complex.i(),
          ]);
          final complex2 = Algebraic.from(const [
            Complex(4, 2),
            Complex.fromImaginary(19),
            Complex(9, -16),
            Complex(-2, 3),
          ]);

          final prod = complex1 * complex2;
          final prodResult = Algebraic.from(const [
            Complex(-6, 12),
            Complex(-55, -4),
            Complex(67, 27),
            Complex(-25, -15),
            Complex(3, 2),
          ]);

          expect(prod, equals(prodResult));
          expect(prod, equals(complex2 * complex1));
          expect(prod, isA<Quartic>());
        });

        test('Division of two polynomials', () {
          final complex1 = Algebraic.from(const [
            Complex.fromReal(1),
            Complex(-3, -1),
            Complex.fromReal(4),
          ]);
          final complex2 = Algebraic.from([
            const Complex.fromReal(1),
            -const Complex.i(),
          ]);

          final div = complex1 / complex2;
          final divResult = (
            quotient: Algebraic.fromReal(const [1, -3]),
            remainder: Algebraic.from(const [Complex(4, -3)]),
          );

          expect(div.quotient, equals(Algebraic.fromReal(const [1, -3])));
          expect(div.remainder, equals(Algebraic.from(const [Complex(4, -3)])));
          expect(div.quotient, isA<Linear>());
          expect(div.remainder, isA<Constant>());
          expect(div, equals(divResult));

          expect(
            div.toString(),
            '(quotient: f(x) = 1x + -3, remainder: f(x) = (4 - 3i))',
          );
        });
      });

      group('Real numbers', () {
        test('Sum of two polynomials', () {
          final quadratic = Algebraic.fromReal([3, -2, 5]);
          final linear = Algebraic.fromReal([4, -10]);

          final sum = quadratic + linear;
          final sumResult = Algebraic.fromReal([3, 2, -5]);

          expect(sum, equals(sumResult));
          expect(sum, equals(linear + quadratic));
          expect(sum, isA<Quadratic>());
        });

        test('Difference of two polynomials', () {
          final quadratic = Algebraic.fromReal([3, -2, 1]);
          final quartic = Algebraic.fromReal([4, 6, 5, -3, 8]);

          final diff = quadratic - quartic;
          final diffResult = Algebraic.fromReal([-4, -6, -2, 1, -7]);

          expect(diff, equals(diffResult));
          expect(quartic - quadratic, equals(-diffResult));
          expect(diffResult, isA<Quartic>());
        });

        test('Product of two polynomials', () {
          final linear = Algebraic.fromReal([2, -2]);
          final cubic = Algebraic.fromReal([1, 0, -4, 5]);

          final prod = linear * cubic;
          final prodResult = Algebraic.fromReal([2, -2, -8, 18, -10]);

          expect(prod, equals(prodResult));
          expect(prod, equals(cubic * linear));
          expect(prod, isA<Quartic>());
        });

        test('Division of two polynomials', () {
          final numerator = Algebraic.fromReal([1, -3, 2]);
          final denominator = Algebraic.fromReal([1, 2]);

          final result = numerator / denominator;

          expect(result, isA<AlgebraicDivision>());
          expect(result.quotient, equals(Algebraic.fromReal([1, -5])));
          expect(result.remainder, equals(Algebraic.fromReal([12])));
          expect(result.quotient, isA<Linear>());
          expect(result.remainder, isA<Constant>());
        });
      });
    });

    group('Factorization', () {
      test('Test 1', () {
        final constant = Algebraic.fromReal([7]);
        final factors = constant.factor();

        expect(factors, hasLength(1));
        expect(factors.first, equals(Constant.realEquation(a: 7)));
      });

      test('Test 2', () {
        final quadratic = Algebraic.fromReal([1, 0, -4]);
        final factors = quadratic.factor();

        expect(factors, hasLength(2));
        expect(factors.first, equals(Linear.realEquation(b: -2)));
        expect(factors.last, equals(Linear.realEquation(b: 2)));
      });

      test('Test 3', () {
        final cubic = Algebraic.fromReal([-2, 2, -35, 7]);
        final factors = cubic.factor();

        // The leading coefficient comes first
        expect(factors, hasLength(4));
        expect(factors.first, equals(Constant.realEquation(a: -2)));
        expect(
          (factors[1] as Linear).b.real,
          const MoreOrLessEquals(-0.3990708079262),
        );
        expect(
          (factors[1] as Linear).b.imaginary,
          const MoreOrLessEquals(-4.144831831735063),
        );
        expect(
          (factors[2] as Linear).b.real,
          const MoreOrLessEquals(-0.20185838414741988),
        );
        expect((factors[2] as Linear).b.imaginary.round(), isZero);
        expect(
          (factors.last as Linear).b.real,
          const MoreOrLessEquals(-0.3990708079262891),
        );
        expect(
          (factors.last as Linear).b.imaginary,
          const MoreOrLessEquals(4.144831831735063),
        );
      });

      test('Test 4', () {
        // x^4 - x^3 + 8x - 8 = (x - 1)(x + 2)(x^2 - 2x + 4)
        final quartic = Algebraic.fromReal([1, -1, 0, 8, -8]);
        final factors = quartic.factor();

        expect(factors, hasLength(4));
        expect(factors, everyElement(isA<Linear>()));

        // Each factor is (x - root), so b = -root. The order of the factors is
        // not part of the API.
        final remaining = factors.map((f) => (f as Linear).b).toList();
        for (final b in const [
          Complex.fromReal(-1),
          Complex.fromReal(2),
          Complex(-1, -1.732050807568),
          Complex(-1, 1.732050807568),
        ]) {
          final index = remaining.indexWhere(
            (x) =>
                (x.real - b.real).abs() < 1e-9 &&
                (x.imaginary - b.imaginary).abs() < 1e-9,
          );
          expect(index, isNot(-1), reason: '$b not found in $remaining');
          remaining.removeAt(index);
        }
      });

      test('Test 5', () {
        final constant = Algebraic.from(const [Complex(6, -3)]);
        final factors = constant.factor();

        expect(factors, hasLength(1));
        expect(factors.first, equals(Constant(a: const Complex(6, -3))));
      });

      test('Test 6', () {
        final quadratic = Algebraic.from(const [
          Complex(-2, 3),
          Complex.fromImaginary(-6),
          Complex(8, 7),
        ]);
        final factors = quadratic.factor();

        // The leading coefficient comes first
        expect(factors, hasLength(3));
        expect(factors.first, equals(Constant(a: const Complex(-2, 3))));
        expect(
          (factors[1] as Linear).b.real,
          const MoreOrLessEquals(-1.7336396048891685),
        );
        expect(
          (factors[1] as Linear).b.imaginary,
          const MoreOrLessEquals(-0.6351453340137784),
        );
        expect(
          (factors.last as Linear).b.real,
          const MoreOrLessEquals(0.3490242202737838),
        );
        expect(
          (factors.last as Linear).b.imaginary,
          const MoreOrLessEquals(1.5582222570907014),
        );
      });

      test('Test 7', () {
        // 2x^2 - 8 = 2(x^2 - 4) = 2(x - 2)(x + 2)
        final quadratic = Algebraic.fromReal([2, 0, -8]);
        final factors = quadratic.factor();

        expect(factors, hasLength(3));
        expect(factors.first, equals(Constant.realEquation(a: 2)));
        expect(factors[1], equals(Linear.realEquation(b: -2)));
        expect(factors.last, equals(Linear.realEquation(b: 2)));
      });

      test('Linear with a non-unit leading coefficient keeps it', () {
        // 2x + 4 = 2(x + 2)
        final factors = Linear.realEquation(a: 2, b: 4).factor();

        expect(
          factors,
          equals([Constant.realEquation(a: 2), Linear.realEquation(b: 2)]),
        );
      });

      test('The product of the factors equals the polynomial', () {
        final polynomials = [
          Algebraic.fromReal([2, 0, -8]),
          Algebraic.fromReal([-3, 6]),
          Algebraic.fromReal([1, -3, 3, -1]),
          Algebraic.fromReal([4, -4, -7, 1, 6]),
        ];

        for (final polynomial in polynomials) {
          final product = polynomial.factor().reduce((a, b) => a * b);

          expect(
            product.coefficients.length,
            polynomial.coefficients.length,
            reason: '$polynomial',
          );
          for (var i = 0; i < product.coefficients.length; ++i) {
            expect(
              product[i].real,
              MoreOrLessEquals(polynomial[i].real, precision: 1.0e-8),
              reason: '$polynomial, coefficient $i',
            );
            expect(
              product[i].imaginary,
              const MoreOrLessEquals(0, precision: 1.0e-8),
              reason: '$polynomial, coefficient $i',
            );
          }
        }
      });
    });

    group('Inequalities', () {
      test('Test 1', () {
        final equation = Quartic(
          a: const Complex.fromReal(2),
          c: const Complex.fromReal(-3),
          d: const Complex.fromReal(1),
        );
        final solutions = equation.solveInequality(
          inequalityType: AlgebraicInequalityType.greaterThan,
        );

        expect(
          solutions.first,
          isA<AlgebraicInequalitySmallerThan>()
              .having(
                (solution) => solution.value,
                'value',
                const MoreOrLessEquals(-1.366025, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                false,
              ),
        );
        expect(
          solutions[1],
          isA<AlgebraicInequalityInterval>()
              .having((solution) => solution.start.round(), 'start', isZero)
              .having(
                (solution) => solution.end,
                'end',
                const MoreOrLessEquals(0.366025, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                false,
              ),
        );
        expect(
          solutions.last,
          isA<AlgebraicInequalityGreaterThan>()
              .having((solution) => solution.value, 'value', 1)
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                false,
              ),
        );
      });

      test('Test 2', () {
        final equation = Quartic(
          a: const Complex.fromReal(2),
          c: const Complex.fromReal(-3),
          d: const Complex.fromReal(1),
        );
        final solutions = equation.solveInequality(
          inequalityType: AlgebraicInequalityType.greaterThanOrEqualTo,
        );

        expect(
          solutions.first,
          isA<AlgebraicInequalitySmallerThan>()
              .having(
                (solution) => solution.value,
                'value',
                const MoreOrLessEquals(-1.366025, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                true,
              ),
        );
        expect(
          solutions[1],
          isA<AlgebraicInequalityInterval>()
              .having((solution) => solution.start.round(), 'start', isZero)
              .having(
                (solution) => solution.end,
                'end',
                const MoreOrLessEquals(0.366025, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                true,
              ),
        );
        expect(
          solutions.last,
          isA<AlgebraicInequalityGreaterThan>()
              .having((solution) => solution.value, 'value', 1)
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                true,
              ),
        );
      });

      test('Test 3', () {
        final equation = Quartic(
          a: const Complex.fromReal(2),
          c: const Complex.fromReal(-3),
          d: const Complex.fromReal(1),
        );
        final solutions = equation.solveInequality(
          inequalityType: AlgebraicInequalityType.lessThan,
        );

        expect(
          solutions.first,
          isA<AlgebraicInequalityInterval>()
              .having(
                (solution) => solution.start,
                'start',
                const MoreOrLessEquals(-1.366025, precision: 1.0e-5),
              )
              .having((solution) => solution.end.round(), 'end', isZero)
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                false,
              ),
        );
        expect(
          solutions.last,
          isA<AlgebraicInequalityInterval>()
              .having(
                (solution) => solution.start,
                'start',
                const MoreOrLessEquals(0.366025, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.end,
                'end',
                const MoreOrLessEquals(1, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                false,
              ),
        );
      });

      test('Test 4', () {
        final equation = Quartic(
          a: const Complex.fromReal(2),
          c: const Complex.fromReal(-3),
          d: const Complex.fromReal(1),
        );
        final solutions = equation.solveInequality(
          inequalityType: AlgebraicInequalityType.lessThanOrEqualTo,
        );

        expect(
          solutions.first,
          isA<AlgebraicInequalityInterval>()
              .having(
                (solution) => solution.start,
                'start',
                const MoreOrLessEquals(-1.366025, precision: 1.0e-5),
              )
              .having((solution) => solution.end.round(), 'end', isZero)
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                true,
              ),
        );
        expect(
          solutions.last,
          isA<AlgebraicInequalityInterval>()
              .having(
                (solution) => solution.start,
                'start',
                const MoreOrLessEquals(0.366025, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.end,
                'end',
                const MoreOrLessEquals(1, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                true,
              ),
        );
      });

      test('Test 5', () {
        expect(
          () =>
              Cubic(
                a: const Complex.fromReal(2),
                c: const Complex(-3, 1),
                d: const Complex.fromReal(1),
              ).solveInequality(
                inequalityType: AlgebraicInequalityType.greaterThan,
              ),
          throwsA(isA<AlgebraicException>()),
        );
      });

      test('Test 6', () {
        expect(
          () =>
              Quadratic(
                a: const Complex.fromReal(2),
                b: const Complex.fromReal(1),
              ).solveInequality(
                inequalityType: AlgebraicInequalityType.lessThan,
                precision: -0.001,
              ),
          throwsA(isA<AlgebraicException>()),
        );
      });

      test('Test 7', () {
        final solutions = Linear(
          a: const Complex.fromReal(7),
          b: const Complex.fromReal(12),
        ).solveInequality(inequalityType: AlgebraicInequalityType.greaterThan);

        expect(
          solutions.first,
          isA<AlgebraicInequalityGreaterThan>()
              .having(
                (solution) => solution.value,
                'value',
                const MoreOrLessEquals(-1.714285, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                false,
              ),
        );
      });

      test('Test 8', () {
        final solutions =
            Linear(
              a: const Complex.fromReal(7),
              b: const Complex.fromReal(12),
            ).solveInequality(
              inequalityType: AlgebraicInequalityType.greaterThanOrEqualTo,
            );

        expect(
          solutions.first,
          isA<AlgebraicInequalityGreaterThan>()
              .having(
                (solution) => solution.value,
                'value',
                const MoreOrLessEquals(-1.714285, precision: 1.0e-5),
              )
              .having(
                (solution) => solution.isInclusive,
                'isInclusive',
                true,
              ),
        );
      });

      test('Test 9', () {
        final solutions =
            Quadratic(
              a: const Complex.fromReal(3),
              b: const Complex.fromReal(5),
              c: const Complex.fromReal(23),
            ).solveInequality(
              inequalityType: AlgebraicInequalityType.greaterThanOrEqualTo,
            );

        expect(solutions.first, isA<AlgebraicInequalityAllRealNumbers>());
      });

      test('Test 10', () {
        final solutions =
            Quadratic(
              a: const Complex.fromReal(3),
              b: const Complex.fromReal(5),
              c: const Complex.fromReal(23),
            ).solveInequality(
              inequalityType: AlgebraicInequalityType.lessThanOrEqualTo,
            );

        expect(solutions.length, isZero);
      });

      test('Negative leading coefficient, >= includes the root', () {
        // -x + 1 >= 0  <=>  x <= 1
        final solutions = Linear.realEquation(a: -1, b: 1).solveInequality(
          inequalityType: AlgebraicInequalityType.greaterThanOrEqualTo,
        );

        expect(solutions, hasLength(1));
        expect(
          solutions.first,
          isA<AlgebraicInequalitySmallerThan>()
              .having((s) => s.value, 'value', 1)
              .having((s) => s.isInclusive, 'isInclusive', true),
        );
      });

      test('Negative leading coefficient, <= includes the root', () {
        // -x + 1 <= 0  <=>  x >= 1
        final solutions = Linear.realEquation(a: -1, b: 1).solveInequality(
          inequalityType: AlgebraicInequalityType.lessThanOrEqualTo,
        );

        expect(solutions, hasLength(1));
        expect(
          solutions.first,
          isA<AlgebraicInequalityGreaterThan>()
              .having((s) => s.value, 'value', 1)
              .having((s) => s.isInclusive, 'isInclusive', true),
        );
      });

      test('Both outer intervals are inclusive for >=', () {
        // x^2 - 1 >= 0  <=>  x <= -1 or x >= 1
        final solutions = Quadratic.realEquation(b: 0, c: -1).solveInequality(
          inequalityType: AlgebraicInequalityType.greaterThanOrEqualTo,
        );

        expect(solutions, hasLength(2));
        expect(
          solutions.first,
          isA<AlgebraicInequalitySmallerThan>()
              .having((s) => s.value, 'value', -1)
              .having((s) => s.isInclusive, 'isInclusive', true),
        );
        expect(
          solutions.last,
          isA<AlgebraicInequalityGreaterThan>()
              .having((s) => s.value, 'value', 1)
              .having((s) => s.isInclusive, 'isInclusive', true),
        );
      });

      test('Both outer intervals are exclusive for >', () {
        // -x^2 + 1 < 0  <=>  x < -1 or x > 1
        final solutions = Quadratic.realEquation(
          a: -1,
          b: 0,
          c: 1,
        ).solveInequality(inequalityType: AlgebraicInequalityType.lessThan);

        expect(solutions, hasLength(2));
        expect(
          solutions.first,
          isA<AlgebraicInequalitySmallerThan>()
              .having((s) => s.value, 'value', -1)
              .having((s) => s.isInclusive, 'isInclusive', false),
        );
        expect(
          solutions.last,
          isA<AlgebraicInequalityGreaterThan>()
              .having((s) => s.value, 'value', 1)
              .having((s) => s.isInclusive, 'isInclusive', false),
        );
      });

      group('Zero polynomial', () {
        final zero = Constant(a: const Complex.zero());

        test('0 < 0 has no solutions', () {
          expect(
            zero.solveInequality(
              inequalityType: AlgebraicInequalityType.lessThan,
            ),
            isEmpty,
          );
        });

        test('0 > 0 has no solutions', () {
          expect(
            zero.solveInequality(
              inequalityType: AlgebraicInequalityType.greaterThan,
            ),
            isEmpty,
          );
        });

        test('0 <= 0 holds for all real numbers', () {
          expect(
            zero.solveInequality(
              inequalityType: AlgebraicInequalityType.lessThanOrEqualTo,
            ),
            [isA<AlgebraicInequalityAllRealNumbers>()],
          );
        });

        test('0 >= 0 holds for all real numbers', () {
          expect(
            zero.solveInequality(
              inequalityType: AlgebraicInequalityType.greaterThanOrEqualTo,
            ),
            [isA<AlgebraicInequalityAllRealNumbers>()],
          );
        });
      });

      test('Negative constant is < 0 everywhere and never >= 0', () {
        final constant = Constant.realEquation(a: -3);

        expect(
          constant.solveInequality(
            inequalityType: AlgebraicInequalityType.lessThan,
          ),
          [isA<AlgebraicInequalityAllRealNumbers>()],
        );
        expect(
          constant.solveInequality(
            inequalityType: AlgebraicInequalityType.greaterThanOrEqualTo,
          ),
          isEmpty,
        );
      });
    });

    group('Evaluation', () {
      test('Real polynomial at a positive value is exact', () {
        // x^2 + 2x + 1 at x = 3
        final result = Quadratic.realEquation(b: 2, c: 1).realEvaluateOn(3);

        expect(result, equals(const Complex.fromReal(16)));
      });

      test('Real polynomial at a negative value has no imaginary part', () {
        // x^2 + 2x + 1 at x = -3
        final quadratic = Quadratic.realEquation(b: 2, c: 1);
        expect(quadratic.realEvaluateOn(-3), equals(const Complex.fromReal(4)));

        // x^3 at x = -2
        final cubic = Cubic.realEquation(b: 0, c: 0, d: 0);
        expect(cubic.realEvaluateOn(-2), equals(const Complex.fromReal(-8)));
      });

      test('Evaluation at zero returns the constant term', () {
        final equation = Algebraic.fromReal([5, -3, 0, 7]);

        expect(equation.realEvaluateOn(0), equals(const Complex.fromReal(7)));
      });

      test('Complex polynomial at a complex value', () {
        // (1 + i)x + 2 at x = i  =>  (1 + i)i + 2 = 1 + i
        final linear = Linear(
          a: const Complex(1, 1),
          b: const Complex.fromReal(2),
        );

        expect(
          linear.evaluateOn(const Complex.i()),
          equals(const Complex(1, 1)),
        );
      });

      test('Integral over a negative interval has no imaginary part', () {
        // integral of x^2 dx from -2 to 0 = 8/3
        final integral = Quadratic.realEquation(
          b: 0,
          c: 0,
        ).evaluateIntegralOn(-2, 0);

        expect(integral.real, const MoreOrLessEquals(8 / 3));
        expect(integral.imaginary, isZero);
      });

      test('Integral of an odd function over a symmetric interval', () {
        // integral of (x^3 - x) dx from -1 to 1 = 0
        final integral = Cubic.realEquation(
          b: 0,
          c: -1,
          d: 0,
        ).evaluateIntegralOn(-1, 1);

        expect(integral, equals(const Complex.zero()));
      });
    });

    group('Operators regressions', () {
      test('Sum keeps zero coefficients in the middle', () {
        // (x^2 + x + 1) + (-x) = x^2 + 1
        final result =
            Algebraic.fromReal([1, 1, 1]) + Algebraic.fromReal([-1, 0]);

        expect(result, equals(Algebraic.fromReal([1, 0, 1])));
      });

      test('Difference keeps zero coefficients in the middle', () {
        // (x^2 + x + 1) - x = x^2 + 1
        final result =
            Algebraic.fromReal([1, 1, 1]) - Algebraic.fromReal([1, 0]);

        expect(result, equals(Algebraic.fromReal([1, 0, 1])));
      });

      test('Sum lowers the degree when leading coefficients cancel', () {
        // (x^2 + 2x) + (-x^2 + 3) = 2x + 3
        final result =
            Algebraic.fromReal([1, 2, 0]) + Algebraic.fromReal([-1, 0, 3]);

        expect(result, isA<Linear>());
        expect(result, equals(Algebraic.fromReal([2, 3])));
      });

      test('p - p is the zero polynomial', () {
        final p = Algebraic.fromReal([3, -1, 4, 1, 5, 9]);

        expect(p - p, equals(Constant(a: const Complex.zero())));
      });

      test('p + (-p) is the zero polynomial', () {
        final p = Algebraic.from(const [Complex(1, 2), Complex(0, -1)]);

        expect(p + (-p), equals(Constant(a: const Complex.zero())));
      });

      test('Product with the zero polynomial is the zero polynomial', () {
        final zero = Constant(a: const Complex.zero());
        final linear = Linear.realEquation(a: 2, b: 1);

        expect(zero * linear, equals(zero));
        expect(linear * zero, equals(zero));
      });

      test('Division matches the AlgebraicDivision docs example', () {
        final result =
            Algebraic.fromReal([1, -3, 2]) / Algebraic.fromReal([1, 2]);

        expect(result.quotient, equals(Algebraic.fromReal([1, -5])));
        expect(result.remainder, equals(Algebraic.fromReal([12])));
      });
    });
  });
}
