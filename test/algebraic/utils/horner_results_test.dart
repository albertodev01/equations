import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the behaviors of the HornerResult class.", () {
    const results = HornerResult(
        [Complex(2, 5), Complex.i(), Complex.fromImaginary(4)], Complex(2, 6));

    test("Making sure that HornerResult values are properly constructed.", () {
      expect(
          results.polynomial,
          orderedEquals(
              <Complex>[Complex(2, 5), Complex.i(), Complex.fromImaginary(4)]));
      expect(results.value, equals(Complex(2, 6)));
    });

    test(("Making sure that HornerResult instances can be properly compared."),
        () {
      const results2 = HornerResult(
          [Complex(2, 5), Complex.i(), Complex.fromImaginary(4)],
          Complex(2, 6));

      expect(results2 == results, isTrue);
      expect(
          results ==
              HornerResult(
                  [Complex(2, 5), Complex.i(), Complex.fromImaginary(4)],
                  Complex(2, 6)),
          isTrue);

      expect(
          results.hashCode,
          equals(HornerResult(
                  [Complex(2, 5), Complex.i(), Complex.fromImaginary(4)],
                  Complex(2, 6))
              .hashCode));
    });
  });
}
