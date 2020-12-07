import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  test("testing parsers", () {
    final expr = ExpressionParser();
    expect(expr.evaluate("3*x", 0).toString(), contains("6"));

    final e = expr.evaluate("sin(4.5*3)^2 - 3", 0).toString();
    expect(e, contains("-2.35393"));
  });
}
