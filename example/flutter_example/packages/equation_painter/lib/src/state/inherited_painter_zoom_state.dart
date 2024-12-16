import 'package:equation_painter/src/equation_painter_widget.dart';
import 'package:equation_painter/src/state/painter_zoom_state.dart';
import 'package:flutter/material.dart';

/// An [InheritedWidget] that exposes a [PainterZoomState] object.
class InheritedPainterZoomState extends InheritedWidget {
  /// The zoom state of [EquationPainterWidget].
  final PainterZoomState painterZoomState;

  /// Creates an [InheritedWidget] that exposes a [PainterZoomState] object.
  const InheritedPainterZoomState({
    required this.painterZoomState,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedPainterZoomState] instance up in the tree.
  static InheritedPainterZoomState of(BuildContext context) {
    final state =
        context.dependOnInheritedWidgetOfExactType<InheritedPainterZoomState>();
    assert(state != null, "No 'InheritedPainterZoomState' found in the tree.");

    return state!;
  }

  @override
  bool updateShouldNotify(covariant InheritedPainterZoomState oldWidget) {
    return painterZoomState != oldWidget.painterZoomState;
  }
}
