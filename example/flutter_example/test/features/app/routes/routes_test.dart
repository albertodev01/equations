import 'package:equations_solver/src/features/app/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Routes', () {
    test('Smoke test', () {
      expect(homeRoute, equals('/'));
      expect(nonlinearRoute, equals('/nonlinear'));
      expect(systemsRoute, equals('/systems'));
    });
  });
}
