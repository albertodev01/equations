import 'package:equations/equations.dart';
import 'package:intl/intl.dart';

/// Extension method on [num] that adds the [toStringApproximated] function.
extension RealNumberPrinter on num {
  /// Prints a decimal number with [maxFractionDigits] without trailing zeroes.
  /// An exception is thrown if [maxFractionDigits] is negative. For example:
  ///
  ///  ```dart
  ///  5.254.toStringApproximated(2) // 5.25
  ///  5.254.toStringApproximated(5) // 5.254
  ///  5.254.toStringApproximated(0) // 5
  ///  5.254.toStringApproximated(-1) // Exception!
  ///  ```
  String toStringApproximated(int maxFractionDigits) {
    if (maxFractionDigits.isNegative) {
      throw const FormatException('Fraction digits value cannot be negative.');
    }

    final formatter = NumberFormat()
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = maxFractionDigits;

    return formatter.format(this);
  }
}

/// Extension method on [Complex] that adds the [toStringApproximated] function.
extension ComplexNumberPrinter on Complex {
  /// Prints a complex number with [maxFractionDigits] without trailing zeroes.
  /// An exception is thrown if [maxFractionDigits] is negative. For example:
  ///
  ///  ```dart
  ///  Complex(1.1543, 3.9847).toStringApproximated(2) // 1.15 + 3.98i
  ///  Complex(1.154, 3.9847).toStringApproximated(5) // 1.154 + 3.9847i
  ///  Complex(1.154, 3.9847).toStringApproximated(0) // 1 + 4i
  ///  Complex(1.154, 3.9847).toStringApproximated(-1) // Exception!
  ///  ```
  String toStringApproximated(int maxFractionDigits) {
    if (maxFractionDigits.isNegative) {
      throw const FormatException('Fraction digits value cannot be negative.');
    }

    final buffer = StringBuffer();
    final formatter = NumberFormat()
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = maxFractionDigits;

    buffer
      ..write(formatter.format(real))
      ..write(imaginary.isNegative ? ' - ' : ' + ')
      ..write(formatter.format(imaginary.abs()))
      ..write('i');

    return buffer.toString();
  }
}
