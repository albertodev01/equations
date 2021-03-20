import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing 'Constant' algebraic equations", () {
    test("Making sure that a 'Constant' object is properly constructed", () {
      final equation = Constant(
        a: const Complex(3, 7),
      );

      // Checking properties
      expect(equation.degree, isZero);
      expect(
        equation.derivative(),
        equals(
          Constant(a: const Complex.zero()),
        ),
      );
      expect(equation.solutions().length, isZero);
      expect(equation.isRealEquation, isFalse);
      expect(equation.coefficients, equals(const [Complex(3, 7)]));

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(const Complex(3, 7)));
      expect(() => equation[-1], throwsA(isA<RangeError>()));
      expect(equation.coefficient(0), equals(const Complex(3, 7)));
      expect(equation.coefficient(1), isNull);

      // Converting to string
      expect(equation.toString(), equals('f(x) = (3 + 7i)'));
      expect(equation.toStringWithFractions(), equals('f(x) = 3 + 7i'));

      // There's NO discriminant for constant values
      final discriminant = equation.discriminant();
      expect(discriminant.real.isNaN, isTrue);
      expect(discriminant.imaginary.isNaN, isTrue);

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval, equals(const Complex(3, 7)));
    });

    test(
        "Making sure that a correct 'Constant' instance is created from a "
        "list of 'double' (real) values", () {
      final constant = Constant.realEquation(a: 5);
      expect(constant.a, equals(const Complex.fromReal(5)));
    });

    test('Making sure that in case of zero, the degree is -inf', () {
      final equation = Constant(a: const Complex.zero());
      expect(equation.degree, equals(double.negativeInfinity));
      expect(equation.isRealEquation, isTrue);

      final eval = equation.realEvaluateOn(6);
      expect(eval, const Complex.zero());
    });

    test('Making sure that objects comparison works properly', () {
      final fx = Constant(a: const Complex.fromReal(6));

      expect(fx, equals(Constant(a: const Complex.fromReal(6))));
      expect(fx == Constant(a: const Complex.fromReal(6)), isTrue);
      expect(
        fx.hashCode,
        equals(Constant(a: const Complex.fromReal(6)).hashCode),
      );
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
      final constant = Constant.realEquation(a: 7);

      // Objects equality
      expect(constant, equals(constant.copyWith()));
      expect(constant, equals(constant.copyWith(a: const Complex(7, 0))));

      // Objects inequality
      expect(
        constant == constant.copyWith(a: const Complex.fromReal(-7)),
        isFalse,
      );
    });
  });
}
