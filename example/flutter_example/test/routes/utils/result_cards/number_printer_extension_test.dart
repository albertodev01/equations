import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/result_cards/number_printer_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing number printers extensions', () {
    test('RealNumberPrinter smoke', () {
      expect(0.27.toStringApproximated(1), '0.3');
      expect(5.254.toStringApproximated(2), '5.25');
      expect(5.254.toStringApproximated(5), '5.254');
      expect(5.254.toStringApproximated(0), '5');
      expect((-5.254).toStringApproximated(2), '-5.25');
      expect((-5.254).toStringApproximated(5), '-5.254');
      expect((-5.254).toStringApproximated(0), '-5');
      expect(() => 5.254.toStringApproximated(-1), throwsFormatException);
    });

    test('ComplexNumberPrinter smoke', () {
      expect(
        const Complex(1.1543, 3.9847).toStringApproximated(2),
        '1.15 + 3.98i',
      );
      expect(
        const Complex(1.154, 3.9847).toStringApproximated(5),
        '1.154 + 3.9847i',
      );
      expect(
        const Complex(1.154, 3.9847).toStringApproximated(0),
        '1 + 4i',
      );
      expect(
        (-const Complex(1.154, 3.9847)).toStringApproximated(2),
        '-1.15 - 3.98i',
      );
      expect(
        (-const Complex(1.154, 3.9847)).toStringApproximated(5),
        '-1.154 - 3.9847i',
      );
      expect(
        (-const Complex(1.154, 3.9847)).toStringApproximated(0),
        '-1 - 4i',
      );
      expect(
        () => const Complex(1.154, 3.9847).toStringApproximated(-1),
        throwsFormatException,
      );
    });
  });
}
