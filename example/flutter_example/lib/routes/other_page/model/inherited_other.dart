import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes an [OtherState] object.
class InheritedOther extends InheritedWidget {
  /// The state of the [OtherPage] page.
  final OtherState otherState;

  /// Creates an [InheritedWidget] that exposes a [InheritedOther] object.
  const InheritedOther({
    required this.otherState,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedOther] instance up in the tree.
  static InheritedOther of(BuildContext context) {
    final ref = context.dependOnInheritedWidgetOfExactType<InheritedOther>();
    assert(ref != null, "No 'InheritedOther' found above in the tree.");

    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedOther oldWidget) {
    return otherState != oldWidget.otherState;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
///[OtherState] up in the tree using [InheritedOther].
extension InheritedOtherExt on BuildContext {
  /// Uses [InheritedOther] to retrieve a [OtherState] object.
  OtherState get otherState => InheritedOther.of(this).otherState;
}
