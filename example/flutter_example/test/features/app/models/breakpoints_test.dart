import 'package:equations_solver/src/features/app/models/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Breakpoints', () {
    test('Smoke test', () {
      expect(desktopNavigationBarBreakpoint, equals(800));
    });
  });
}
