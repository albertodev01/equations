import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Handles the state of a [DropdownButtonFormField] widget.
class DropdownCubit extends Cubit<String> {
  /// The [initialValue] will be the default selection of the dropdown.
  DropdownCubit({
    required String initialValue,
  }) : super(initialValue);

  /// Updates the currently selected item of the dropdown.
  void changeValue(String newValue) => emit(newValue);
}