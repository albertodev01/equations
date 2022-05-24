import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NumberSwitcherState' class", () {
    test('Initial values', () {
      final numberSwitcher = NumberSwitcherState(min: 1, max: 5);

      expect(numberSwitcher.min, equals(1));
      expect(numberSwitcher.max, equals(5));
      expect(numberSwitcher.state, equals(1));
    });

    test('Making sure that increase and decrease methods work correctly', () {
      var notifyCounter = 0;
      final numberSwitcher = NumberSwitcherState(min: 1, max: 5)
        ..addListener(() => ++notifyCounter);

      expect(notifyCounter, isZero);
      expect(numberSwitcher.state, equals(1));

      // Increasing
      numberSwitcher.increase();
      expect(notifyCounter, equals(1));
      expect(numberSwitcher.state, equals(2));

      // Decreasing
      numberSwitcher.decrease();
      expect(notifyCounter, equals(2));
      expect(numberSwitcher.state, equals(1));

      // Increasing more than the max. allowed
      numberSwitcher
        ..increase()
        ..increase()
        ..increase()
        ..increase()
        ..increase()
        ..increase()
        ..increase()
        ..increase();
      expect(notifyCounter, equals(6));
      expect(numberSwitcher.state, equals(5));

      // Reset
      numberSwitcher.reset();

      expect(notifyCounter, equals(7));
      expect(numberSwitcher.state, equals(1));
    });
  });
}
