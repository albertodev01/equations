import 'package:flutter/widgets.dart';

/// TODO
class InheritedDropdownValue extends InheritedWidget {
  final ValueNotifier<String> dropdownValue;

  /// Creates an [InheritedWidget] that exposes a [ValueNotifier] object.
  const InheritedDropdownValue({
    super.key,
    required this.dropdownValue,
    required super.child,
  });

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

extension InheritedDropdownValueExt on BuildContext {
  ValueNotifier<String> get dropdownValue =>
      InheritedDropdownValue.of(this).dropdownValue;
}
