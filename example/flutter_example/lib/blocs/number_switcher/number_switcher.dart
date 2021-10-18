import 'package:flutter_bloc/flutter_bloc.dart';

/// This cubit keeps the state of an [int] in the `min <= x <= max` range.
class NumberSwitcherCubit extends Cubit<int> {
  /// The minimum allowed value.
  final int min;

  /// The maximum allowed value.
  final int max;

  /// Creates a [NumberSwitcherCubit] instance and sets [min] as initial state.
  NumberSwitcherCubit({
    required this.min,
    required this.max,
  }) : super(min);

  /// Increases the value by 1.
  void increase() => _changeValue(state + 1);

  /// Decreases the value by 1.
  void decrease() => _changeValue(state - 1);

  /// Updates the currently selected item of the dropdown.
  void _changeValue(int newValue) {
    if ((newValue >= min) && (newValue <= max)) {
      emit(newValue);
    }
  }
}
