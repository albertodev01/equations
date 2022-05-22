import 'package:equations_solver/routes/models/system_text_controllers/system_text_controllers.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedSystemControllers extends InheritedWidget {
  final SystemTextControllers systemTextControllers;

  /// Creates an [InheritedWidget] that exposes a [SystemTextControllers] object.
  const InheritedSystemControllers({
    super.key,
    required this.systemTextControllers,
    required super.child,
  });

  static InheritedSystemControllers of(BuildContext context) {
    final ref = context
        .dependOnInheritedWidgetOfExactType<InheritedSystemControllers>();
    assert(ref != null,
        "No 'InheritedSystemControllers' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedSystemControllers oldWidget) {
    return systemTextControllers != oldWidget.systemTextControllers;
  }
}

extension InheritedSystemControllersExt on BuildContext {
  SystemTextControllers get systemTextControllers =>
      InheritedSystemControllers.of(this).systemTextControllers;
}
