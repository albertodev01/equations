import 'package:equations_solver/routes/utils/collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This cubit handles the opened or closed state of a widget.
///
/// For example, this cubit can handle the open/closed status of an
/// [ExpansionPanel] or a [Collapsible] widget.
class ExpansionCubit extends Cubit<bool> {
  /// Creates an instance of [ExpansionCubit].
  ExpansionCubit() : super(false);

  /// Toggles the open/closed state of the cubit.
  void toggle() => emit(!state);
}
