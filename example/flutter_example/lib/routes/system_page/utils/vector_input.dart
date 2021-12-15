import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// Creates a column of [SystemInputField] to input the known values vector
/// of the system.
class VectorInput extends StatefulWidget {
  /// Determines the size of the vector.
  final List<TextEditingController> vectorControllers;

  /// The size of the vector.
  final int vectorSize;

  /// Creates a [VectorInput] widget.
  const VectorInput({
    Key? key,
    required this.vectorControllers,
    required this.vectorSize,
  }) : super(key: key);

  @override
  _VectorInputState createState() => _VectorInputState();
}

class _VectorInputState extends State<VectorInput> {
  /// The children of the [Column] widget, representing the vector.
  late List<Widget> children = _vectorChildren();

  /// Builds the [Column]'s children that will contain the input fields for the
  /// known values vector
  List<Widget> _vectorChildren() {
    final entry = <Widget>[];

    for (var i = 0; i < widget.vectorSize; ++i) {
      entry.add(
        Padding(
          padding: i == 0
              ? const EdgeInsets.all(0)
              : const EdgeInsets.only(top: 10),
          child: SystemInputField(
            controller: widget.vectorControllers[i],
          ),
        ),
      );
    }

    return entry;
  }

  @override
  void didUpdateWidget(covariant VectorInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.vectorSize != oldWidget.vectorSize) {
      children = _vectorChildren();
    }
  }

  @override
  Widget build(BuildContext context) {
    // We're adding '5' to the overall width to make sure that tiles aren't too
    // close each other.
    final boxWidth = systemInputFieldSize.width + 5;

    return Center(
      child: SizedBox(
        width: boxWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
