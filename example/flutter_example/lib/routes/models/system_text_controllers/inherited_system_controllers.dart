import 'package:equations_solver/routes/models/system_text_controllers/system_text_controllers.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [SystemTextControllers] object.
class InheritedSystemControllers extends InheritedWidget {
  /// The matrix and vectors text controllers.
  final SystemTextControllers systemTextControllers;

  /// Creates an [InheritedWidget] that exposes a [SystemTextControllers]
  /// object.
  const InheritedSystemControllers({
    required this.systemTextControllers,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedSystemControllers] instance up in the
  /// tree.
  static InheritedSystemControllers of(BuildContext context) {
    final ref = context
        .dependOnInheritedWidgetOfExactType<InheritedSystemControllers>();
    assert(
      ref != null,
      "No 'InheritedSystemControllers' found above in the tree.",
    );

    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedSystemControllers oldWidget) {
    return systemTextControllers != oldWidget.systemTextControllers;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
/// [SystemTextControllers] up in the tree using [InheritedSystemControllers].
extension InheritedSystemControllersExt on BuildContext {
  /// Uses [InheritedSystemControllers] to retrieve a [SystemTextControllers]
  /// object.
  SystemTextControllers get systemTextControllers =>
      InheritedSystemControllers.of(this).systemTextControllers;
}
