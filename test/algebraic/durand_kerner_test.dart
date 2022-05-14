import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'DurandKerner' class for polynomial roots finding", () {
    test(
      "Making sure that a 'DurandKerner' object is properly constructed",
      () {
        final equation = DurandKerner(
          coefficients: const [
            Complex.i(),
            Complex.fromReal(3),
            Complex(5, 6),
          ],
        );

        // Checking properties
        expect(equation.degree, equals(2));
        expect(equation.derivative(), isA<Linear>());
        expect(equation.isRealEquation, isFalse);
        expect(equation.discriminant(), const Complex(33, -20));
        expect(
          equation.coefficients,
          equals(
            const [
              Complex.i(),
              Complex.fromReal(3),
              Complex(5, 6),
            ],
          ),
        );

        // Making sure that coefficients can be accessed via index
        expect(equation[0], equals(const Complex.i()));
        expect(equation[1], equals(const Complex.fromReal(3)));
        expect(equation[2], equals(const Complex(5, 6)));

        expect(() => equation[-1], throwsA(isA<RangeError>()));

        expect(equation.coefficient(2), equals(const Complex.i()));
        expect(equation.coefficient(1), equals(const Complex.fromReal(3)));
        expect(equation.coefficient(0), equals(const Complex(5, 6)));
        expect(equation.coefficient(3), isNull);

        // Converting to string
        expect(
          equation.toString(),
          equals('f(x) = 1ix^2 + 3x + (5 + 6i)'),
        );
        expect(
          equation.toStringWithFractions(),
          equals('f(x) = 1ix^2 + 3x + (5 + 6i)'),
        );

        // Checking solutions
        final solutions = equation.solutions();

        expect(
          solutions[1].real,
          const MoreOrLessEquals(-0.8357, precision: 1.0e-4),
        );
        expect(
          solutions[1].imaginary,
          const MoreOrLessEquals(-1.4914, precision: 1.0e-4),
        );
        expect(
          solutions.first.real,
          const MoreOrLessEquals(0.8357, precision: 1.0e-4),
        );
        expect(
          solutions.first.imaginary,
          const MoreOrLessEquals(4.4914, precision: 1.0e-4),
        );

        // Evaluation
        final eval = equation.realEvaluateOn(2);
        expect(eval, equals(const Complex(11, 10)));
      },
    );

    test(
      'Making sure that, when the polynomial degree is 0 (so it is a simple '
      'constant, the returned list is empty.',
      () {
        final noSolutions = DurandKerner.realEquation(
          coefficients: [1],
        );

        expect(noSolutions.solutions().length, isZero);
      },
    );

    test(
      "Making sure that a correct 'DurandKerner' instance is created from a"
      " list of 'double' (real) values",
      () {
        final durandKerner = DurandKerner.realEquation(
          coefficients: [1, 2, 3],
        );

        expect(durandKerner[0], equals(const Complex.fromReal(1)));
        expect(durandKerner[1], equals(const Complex.fromReal(2)));
        expect(durandKerner[2], equals(const Complex.fromReal(3)));

        // There must be an exception is the first coeff. is zero
        expect(
          () => DurandKerner.realEquation(
            coefficients: [0, 3, 6],
          ),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test(
      'Making sure that an exception is thrown if the coefficient with the '
      'highest degree is zero',
      () {
        expect(
          () => DurandKerner(
            coefficients: const [Complex.zero()],
          ),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test('Making sure that derivatives types are correct.', () {
      final polynomialDegree6 = DurandKerner.realEquation(
        coefficients: [1, 2, 3, 4, 5, 6, 7],
      );
      final polynomialDegree5 = DurandKerner.realEquation(
        coefficients: [1, 2, 3, 4, 5, 6],
      );
      final polynomialDegree4 = DurandKerner.realEquation(
        coefficients: [1, 2, 3, 4, 5],
      );
      final polynomialDegree3 = DurandKerner.realEquation(
        coefficients: [1, 2, 3, 4],
      );
      final polynomialDegree2 = DurandKerner.realEquation(
        coefficients: [1, 2, 3],
      );
      final polynomialDegree1 = DurandKerner.realEquation(
        coefficients: [1, 2],
      );
      final polynomialDegree0 = DurandKerner.realEquation(
        coefficients: [1],
      );

      expect(polynomialDegree6.derivative(), isA<DurandKerner>());
      expect(polynomialDegree5.derivative(), isA<Quartic>());
      expect(polynomialDegree4.derivative(), isA<Cubic>());
      expect(polynomialDegree3.derivative(), isA<Quadratic>());
      expect(polynomialDegree2.derivative(), isA<Linear>());
      expect(polynomialDegree1.derivative(), isA<Constant>());
      expect(polynomialDegree0.derivative(), isA<Constant>());
    });

    test(
      'Making sure that the derivative of a polynomial whose degree is > 4'
      ' are correctly computed.',
      () {
        final durandKerner1 = DurandKerner.realEquation(
          coefficients: [2, 0, -2, 0, 7, 0],
        );

        expect(
          durandKerner1.derivative(),
          equals(Algebraic.fromReal(
            [10, 0, -6, 0, 7],
          ),),
        );
        expect(
          durandKerner1.discriminant().real,
          equals(29679104),
        );
        expect(
          durandKerner1.discriminant().imaginary,
          isZero,
        );

        final durandKerner2 = DurandKerner.realEquation(
          coefficients: [1, -5, 2, -2, 0, 7, 13],
        );

        expect(
          durandKerner2.derivative(),
          equals(Algebraic.fromReal(
            [6, -25, 8, -6, 0, 7],
          ),),
        );
        expect(
          durandKerner2.discriminant().real.round(),
          equals(1002484790644),
        );
        expect(
          durandKerner2.discriminant().imaginary,
          isZero,
        );
      },
    );

    test('Making sure that objects comparison works properly', () {
      final fx = DurandKerner.realEquation(
        coefficients: [1, 2, 3, 4, 5],
      );
      final otherFx = DurandKerner.realEquation(
        coefficients: [1, 2, 3, 4, 5],
      );

      final notEqual = DurandKerner.realEquation(
        coefficients: [1, 2, 3, 4, 5],
        initialGuess: List<Complex>.generate(4, (_) => const Complex.zero()),
      );

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(otherFx, equals(fx));
      expect(otherFx == fx, isTrue);

      expect(
        fx,
        equals(DurandKerner.realEquation(
          coefficients: [1, 2, 3, 4, 5],
        ),),
      );
      expect(
        DurandKerner.realEquation(
          coefficients: [1, 2, 3, 4, 5],
        ),
        equals(fx),
      );

      expect(fx.hashCode, equals(otherFx.hashCode));

      expect(fx == notEqual, isFalse);
      expect(fx.hashCode == notEqual.hashCode, isFalse);

      expect(
        DurandKerner(
          coefficients: const [
            Complex(3, -2),
            Complex.zero(),
            Complex.fromReal(7),
          ],
          initialGuess: const [
            Complex(3, 2),
            Complex.fromImaginary(8),
          ],
        ),
        equals(
          DurandKerner(
            coefficients: const [
              Complex(3, -2),
              Complex.zero(),
              Complex.fromReal(7),
            ],
            initialGuess: const [
              Complex(3, 2),
              Complex.fromImaginary(8),
            ],
          ),
        ),
      );
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
      final durandKerner = DurandKerner.realEquation(
        coefficients: [1, 2, 3],
      );

      // Objects equality
      expect(
        durandKerner,
        equals(durandKerner.copyWith()),
      );
      expect(
        durandKerner,
        equals(
          durandKerner.copyWith(
            maxSteps: 2000,
          ),
        ),
      );

      // Objects inequality
      expect(
        durandKerner ==
            durandKerner.copyWith(
              maxSteps: 1,
            ),
        isFalse,
      );
    });

    test('Batch tests', () {
      final equations = [
        DurandKerner.realEquation(
          coefficients: [2, 3, -11, -6],
        ).solutions(),
        DurandKerner.realEquation(
          coefficients: [1, -5, 2, -2, 0, 7, 13],
          precision: 1.0e-15,
        ).solutions(),
        DurandKerner.realEquation(
          coefficients: [2, 1, -2, 1, 7],
          precision: 1.0e-15,
        ).solutions(),
        DurandKerner(
          coefficients: const [
            Complex(3, -2),
            Complex.zero(),
            Complex.fromReal(7),
            Complex.fromReal(-1),
          ],
        ).solutions(),
        DurandKerner(
          coefficients: const [
            Complex.fromReal(1),
            Complex.zero(),
            Complex.i(),
            Complex.zero(),
            Complex.zero(),
            Complex(1, -6),
          ],
        ).solutions(),
        DurandKerner.realEquation(
          coefficients: [
            1,
            2,
            1,
          ],
          initialGuess: const [
            Complex.fromReal(-2),
            Complex.fromReal(-2),
          ],
        ).solutions(),
      ];

      final solutions = <List<Complex>>[
        const [
          Complex.fromReal(2),
          Complex.fromReal(-3),
          Complex.fromReal(-0.5),
        ],
        const [
          Complex(-0.823, -0.5491),
          Complex(0.2501, 1.3561),
          Complex.fromReal(1.5048),
          Complex(0.2501, -1.3561),
          Complex.fromReal(4.6407),
          Complex(-0.823, 0.5491),
        ],
        const [
          Complex(-1.2215, 0.6934),
          Complex(0.9715, 0.911),
          Complex(0.9715, -0.911),
          Complex(-1.2215, -0.6934),
        ],
        const [
          Complex(0.1416, 0.0007),
          Complex(-0.4731, 1.3384),
          Complex(0.3314, -1.3391),
        ],
        const [
          Complex(-0.7022, -1.1129),
          Complex(1.2952, 0.3689),
          Complex(1.0034, -1.2234),
          Complex(-1.4083, 0.5424),
          Complex(-0.1881, 1.425),
        ],
        const [
          Complex.fromReal(-1),
          Complex.fromReal(-1),
        ],
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          expect(
            equations[i][j].real,
            MoreOrLessEquals(solutions[i][j].real, precision: 1.0e-4),
          );
          expect(
            equations[i][j].imaginary,
            MoreOrLessEquals(solutions[i][j].imaginary, precision: 1.0e-4),
          );
        }
      }
    });
  });
}
