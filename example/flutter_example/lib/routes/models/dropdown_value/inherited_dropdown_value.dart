import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [ValueNotifier] object.
class InheritedDropdownValue extends InheritedWidget {
  /// The dropdown state, which also indicates the currently selected item.
  final ValueNotifier<String> dropdownValue;

  /// Creates an [InheritedWidget] that exposes a [ValueNotifier] object.
  const InheritedDropdownValue({
    super.key,
    required this.dropdownValue,
    required super.child,
  });

  /// Retrieves the closest [InheritedDropdownValue] instance up in the tree.
  static InheritedDropdownValue of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedDropdownValue>();
    assert(ref != null, "No 'InheritedDropdownValue' found above in the tree.");

    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedDropdownValue oldWidget) {
    return dropdownValue != oldWidget.dropdownValue;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
/// [ValueNotifier] up in the tree using [InheritedDropdownValue].
extension InheritedDropdownValueExt on BuildContext {
  /// Uses [InheritedDropdownValue] to retrieve a [ValueNotifier] object.
  ValueNotifier<String> get dropdownValue =>
      InheritedDropdownValue.of(this).dropdownValue;
}
