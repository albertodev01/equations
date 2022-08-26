import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// Creates a column of [SystemInputField] to input the known values vector
/// of the system.
class VectorInput extends StatefulWidget {
  /// The text controllers of the known values vector.
  final List<TextEditingController> vectorControllers;

  /// The actual size of the vector.
  final int vectorSize;

  /// Creates a [VectorInput] widget.
  const VectorInput({
    required this.vectorControllers,
    required this.vectorSize,
    super.key,
  });

  @override
  State<VectorInput> createState() => _VectorInputState();
}

class _VectorInputState extends State<VectorInput> {
  /// The children of the [Column] widget, representing the vector.
  late Widget vectorChildren = _VectorChildren(
    vectorControllers: widget.vectorControllers,
    vectorSize: widget.vectorSize,
  );

  @override
  void didUpdateWidget(covariant VectorInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.vectorSize != oldWidget.vectorSize) {
      vectorChildren = _VectorChildren(
        vectorControllers: widget.vectorControllers,
        vectorSize: widget.vectorSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // We're adding '5' to the overall width to make sure that tiles aren't too
    // close each other.
    const boxWidth = systemInputFieldSize + 5;

    return Center(
      child: SizedBox(
        width: boxWidth,
        child: vectorChildren,
      ),
    );
  }
}

/// Returns the the children that will contain the input fields for the known
/// values vector.
class _VectorChildren extends StatelessWidget {
  /// The text controllers of the known values vector.
  final List<TextEditingController> vectorControllers;

  /// The actual size of the vector.
  final int vectorSize;

  /// Creates a [_VectorChildren] widget.
  const _VectorChildren({
    required this.vectorControllers,
    required this.vectorSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < vectorSize; ++i)
          Padding(
            padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
            child: SystemInputField(
              key: Key('VectorEntry-$i'),
              controller: vectorControllers[i],
            ),
          ),
      ],
    );
  }
}
