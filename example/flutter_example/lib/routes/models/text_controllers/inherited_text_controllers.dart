import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a list of [TextEditingController] object.
class InheritedTextControllers extends InheritedWidget {
  /// The text controllers state used to persist the value across tabs or
  /// text fields being deactivated.
  final List<TextEditingController> textControllers;

  /// Creates an [InheritedWidget] that exposes a list of
  /// [TextEditingController] objects.
  const InheritedTextControllers({
    super.key,
    required this.textControllers,
    required super.child,
  });

  /// Retrieves the closest [InheritedTextControllers] instance up in the tree.
  static InheritedTextControllers of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedTextControllers>();
    assert(
      ref != null,
      "No 'InheritedTextControllers' found above in the tree.",
    );

    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedTextControllers oldWidget) {
    return textControllers != oldWidget.textControllers;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
/// list of [TextEditingController]s up in the tree using
/// [InheritedTextControllers].
extension InheritedTextControllersExt on BuildContext {
  /// Uses [InheritedTextControllers] to retrieve the [TextEditingController]
  /// list.
  List<TextEditingController> get textControllers =>
      InheritedTextControllers.of(this).textControllers;
}
