import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This cubit is used to remember the values of [TextFormField] widgets to that
/// the input can persist even if the widget rebuilt.
class TextFieldValuesCubit extends Cubit<Map<int, String>> {
  /// Creates a [TextFieldValuesCubit] with an empty map as initial state.
  TextFieldValuesCubit() : super(const {});

  /// Stores the value at the given TextField index.
  void setValue({
    required int index,
    required String value,
  }) {
    final newState = Map<int, String>.from(state)
      ..update(
        index,
        (_) => value,
        ifAbsent: () => value,
      );

    emit(newState);
  }

  /// Gets the TextField value at the given [index].
  ///
  /// Returns an empty string if there is no text associated to the [index].
  String getValue(int index) => state[index] ?? '';

  /// Clears all the values.
  void reset() => emit(const {});
}
