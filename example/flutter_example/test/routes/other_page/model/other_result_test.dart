import 'package:equations/equations.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/complex_result_wrapper.dart';
import 'package:equations_solver/routes/other_page/model/other_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'OtherResult' class", () {
    test('Initial values', () {
      const otherResult = OtherResult(
        results: ComplexResultWrapper(
          polarComplex: PolarComplex(
            r: 1,
            phiRadians: 1,
            phiDegrees: 1,
          ),
          conjugate: Complex.zero(),
          reciprocal: Complex.zero(),
          abs: 1,
          sqrt: Complex.zero(),
          phase: 1,
        ),
      );

      expect(otherResult.results, isA<ComplexResultWrapper>());
    });

    test('Making sure that objects can be properly compared', () {
      const otherResult = OtherResult(
        results: ComplexResultWrapper(
          polarComplex: PolarComplex(
            r: 1,
            phiRadians: 1,
            phiDegrees: 1,
          ),
          conjugate: Complex.zero(),
          reciprocal: Complex.zero(),
          abs: 1,
          sqrt: Complex.zero(),
          phase: 1,
        ),
      );

      expect(
        otherResult,
        equals(
          const OtherResult(
            results: ComplexResultWrapper(
              polarComplex: PolarComplex(
                r: 1,
                phiRadians: 1,
                phiDegrees: 1,
              ),
              conjugate: Complex.zero(),
              reciprocal: Complex.zero(),
              abs: 1,
              sqrt: Complex.zero(),
              phase: 1,
            ),
          ),
        ),
      );

      expect(
        const OtherResult(
          results: ComplexResultWrapper(
            polarComplex: PolarComplex(
              r: 1,
              phiRadians: 1,
              phiDegrees: 1,
            ),
            conjugate: Complex.zero(),
            reciprocal: Complex.zero(),
            abs: 1,
            sqrt: Complex.zero(),
            phase: 1,
          ),
        ),
        otherResult,
      );

      expect(
        otherResult ==
            const OtherResult(
              results: ComplexResultWrapper(
                polarComplex: PolarComplex(
                  r: 1,
                  phiRadians: 1,
                  phiDegrees: 1,
                ),
                conjugate: Complex.zero(),
                reciprocal: Complex.zero(),
                abs: 1,
                sqrt: Complex.zero(),
                phase: 1,
              ),
            ),
        isTrue,
      );

      expect(
        const OtherResult(
              results: ComplexResultWrapper(
                polarComplex: PolarComplex(
                  r: 1,
                  phiRadians: 1,
                  phiDegrees: 1,
                ),
                conjugate: Complex.zero(),
                reciprocal: Complex.zero(),
                abs: 1,
                sqrt: Complex.zero(),
                phase: 1,
              ),
            ) ==
            otherResult,
        isTrue,
      );

      expect(
        const OtherResult(
              results: ComplexResultWrapper(
                polarComplex: PolarComplex(
                  r: 1,
                  phiRadians: 1,
                  phiDegrees: 1,
                ),
                conjugate: Complex.zero(),
                reciprocal: Complex.zero(),
                abs: 1,
                sqrt: Complex.zero(),
                phase: 2,
              ),
            ) ==
            otherResult,
        isFalse,
      );

      expect(
        otherResult.hashCode,
        equals(
          const OtherResult(
            results: ComplexResultWrapper(
              polarComplex: PolarComplex(
                r: 1,
                phiRadians: 1,
                phiDegrees: 1,
              ),
              conjugate: Complex.zero(),
              reciprocal: Complex.zero(),
              abs: 1,
              sqrt: Complex.zero(),
              phase: 1,
            ),
          ).hashCode,
        ),
      );
    });
  });
}
