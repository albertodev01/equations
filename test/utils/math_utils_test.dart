import 'package:equations/equations.dart';
import 'package:equations/src/utils/math_utils.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

class Demo with MathUtils {
  const Demo();
}

void main() {
  late final Demo demo;

  setUpAll(() {
    demo = const Demo();
  });

  group("Testing the 'MathUtils' mixin", () {
    test("Making sure that the 'hypot' method works correctly", () {
      expect(demo.hypot(0, 0), isZero);
      expect(demo.hypot(0, 8), equals(8));
      expect(demo.hypot(8, 0), equals(8));
      expect(demo.hypot(3, 4), equals(5));
    });

    test("Making sure that the 'complexHypot' method works correctly", () {
      expect(
        demo.complexHypot(const Complex.zero(), const Complex.zero()),
        equals(const Complex.zero()),
      );
      expect(
        demo.complexHypot(const Complex.zero(), const Complex.i()),
        equals(const Complex.i()),
      );
      expect(
        demo.complexHypot(const Complex.i(), const Complex.zero()),
        equals(const Complex.i()),
      );
      expect(
        demo.complexHypot(const Complex.fromReal(3), const Complex.fromReal(4)),
        equals(const Complex.fromReal(5)),
      );

      final hypot = demo.complexHypot(
        const Complex(-2, 6),
        const Complex.fromImaginary(6),
      );
      expect(
        hypot.real,
        const MoreOrLessEquals(-1.4337, precision: 1.0e-5),
      );
      expect(
        hypot.imaginary,
        const MoreOrLessEquals(8.36991, precision: 1.0e-5),
      );
    });
  });
}
