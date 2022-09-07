import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing breakpoints', () {
    test('Smoke test', () {
      expect(bottomNavigationBreakpoint, equals(950.0));
      expect(extraBackgroundBreakpoint, equals(1300.0));
      expect(doubleColumnPageBreakpoint, equals(1100.0));
      expect(maxWidthPlot, equals(600.0));
      expect(minimumChartWidth, equals(350.0));
      expect(matricesPageColumnWidth, equals(cardWidgetsWidth + 30 * 2));
      expect(complexNumbersPageColumnWidth, equals(cardWidgetsWidth + 30 * 2));
      expect(cardWidgetsWidth, equals(275.0));
      expect(resultCardPrecisionDigits, equals(5));
      expect(collapsibleInnerSpacing, equals(16.0));
      expect(polynomialInputFieldWidth, equals(70.0));
      expect(nonlinearDropdownWidth, equals(200.0));
      expect(systemDropdownWidth, equals(250.0));
      expect(integralDropdownWidth, equals(200.0));
      expect(precisonSliderWidth, equals(300.0));
      expect(systemInputFieldSize, equals(60.0));
      expect(nonlinearValuesWidth, equals(80.0));
      expect(integrationBoundsWidth, equals(80.0));
      expect(complexInputWidth, equals(65.0));
      expect(matrixOutputWidth, equals(70.0));
    });
  });
}
