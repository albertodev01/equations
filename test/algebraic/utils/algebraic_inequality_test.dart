// Done on purpose to test the equality operators
// ignore_for_file: prefer_const_constructors

import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('AlgebraicInequalitySolution', () {
    test('AlgebraicInequalityInterval smoke test', () {
      expect(
        AlgebraicInequalityInterval(
          start: 10,
          end: 5,
          isInclusive: false,
        ),
        equals(
          AlgebraicInequalityInterval(
            start: 10,
            end: 5,
            isInclusive: false,
          ),
        ),
      );
      expect(
        AlgebraicInequalityInterval(
          start: 10,
          end: 5,
          isInclusive: false,
        ).hashCode,
        equals(
          AlgebraicInequalityInterval(
            start: 10,
            end: 5,
            isInclusive: false,
          ).hashCode,
        ),
      );
      expect(
        AlgebraicInequalityInterval(
          start: 10,
          end: 5,
          isInclusive: false,
        ).toString(),
        equals('Interval(start: 10.0, end: 5.0, isInclusive: false)'),
      );
    });

    test('AlgebraicInequalitySmallerThan smoke test', () {
      expect(
        AlgebraicInequalitySmallerThan(value: 5, isInclusive: false),
        equals(AlgebraicInequalitySmallerThan(value: 5, isInclusive: false)),
      );
      expect(
        AlgebraicInequalitySmallerThan(value: 5, isInclusive: false).hashCode,
        equals(
          AlgebraicInequalitySmallerThan(value: 5, isInclusive: false).hashCode,
        ),
      );
      expect(
        AlgebraicInequalitySmallerThan(value: 5, isInclusive: false).toString(),
        equals('SmallerThan(value: 5.0, isInclusive: false)'),
      );
    });

    test('AlgebraicInequalityGreaterThan smoke test', () {
      expect(
        AlgebraicInequalityGreaterThan(value: 5, isInclusive: false),
        equals(AlgebraicInequalityGreaterThan(value: 5, isInclusive: false)),
      );
      expect(
        AlgebraicInequalityGreaterThan(value: 5, isInclusive: false).hashCode,
        equals(
          AlgebraicInequalityGreaterThan(value: 5, isInclusive: false).hashCode,
        ),
      );
      expect(
        AlgebraicInequalityGreaterThan(value: 5, isInclusive: false).toString(),
        equals('GreaterThan(value: 5.0, isInclusive: false)'),
      );
    });

    test('AlgebraicInequalityAllRealNumbers smoke test', () {
      expect(
        AlgebraicInequalityAllRealNumbers(),
        equals(AlgebraicInequalityAllRealNumbers()),
      );
      expect(
        AlgebraicInequalityAllRealNumbers().hashCode,
        equals(AlgebraicInequalityAllRealNumbers().hashCode),
      );
      expect(
        AlgebraicInequalityAllRealNumbers().toString(),
        equals('AllRealNumbers(isInclusive: true)'),
      );
    });
  });
}
