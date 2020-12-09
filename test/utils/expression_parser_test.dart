import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the correctness of exception objects", () {
    test("Making sure that 'ExpressionParser' works with real numbers.", () {
      const parser = ExpressionParser();

      expect(parser.evaluate("5*3-4"), equals(11));
      expect(parser.evaluate("3/8 + 2^3"), equals(8.375));
      expect(parser.evaluate("pi"),
          MoreOrLessEquals(3.1415926535, precision: 1.0e-10));
      expect(parser.evaluate("e"),
          MoreOrLessEquals(2.7182818284, precision: 1.0e-10));
    });

    test("Making sure that 'ExpressionParser' works with the 'x' variable.", () {
      const parser = ExpressionParser();
      expect(parser.evaluateOn("6*x + 4", 3), equals(22));
    });

    test("Making sure that 'ExpressionParser' works with the 'x' variable even"
        "if 'x' is not present.", () {
      const parser = ExpressionParser();
      expect(parser.evaluateOn("6*3 + 4", 0), equals(22));
    });

    test("Making sure that math functions are properly evaluated.", () {
      const parser = ExpressionParser();

      //expect(parser.evaluate("sqrt(49)"), equals(7));
    });
  });
}
