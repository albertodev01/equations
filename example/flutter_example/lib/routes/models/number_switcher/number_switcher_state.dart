import 'package:flutter/widgets.dart';

/// This listenable class keeps the state of an [int] in the [min] <= x <= [max]
/// range.
class NumberSwitcherState extends ChangeNotifier {
  int _counter;

  /// The minimum allowed value.
  final int min;

  /// The maximum allowed value.
  final int max;

  /// Creates a [NumberSwitcherState] instance and sets [min] as initial state.
  NumberSwitcherState({
    required this.min,
    required this.max,
  }) : _counter = min;

  /// The current counter value;
  int get state => _counter;

  /// Increases the value by 1.
  void increase() => _changeValue(_counter + 1);

  /// Decreases the value by 1.
  void decrease() => _changeValue(_counter - 1);

  /// Brings the state to the [min] value.
  void reset() {
    _counter = min;
    notifyListeners();
  }

  /// Updates the current value **only** when `min <= newValue <= max`.
  void _changeValue(int newValue) {
    if ((newValue >= min) && (newValue <= max)) {
      _counter = newValue;
      notifyListeners();
    }
  }
}
