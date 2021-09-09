import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:flutter/material.dart';

/// Creates an column of [SystemInputField] to input the known values vector
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

  /// Builds the [Column] widget that will contain the input fields for the
  /// known values vector
  List<Widget> _vectorChildren() {
    final entry = <Widget>[];

    for (var i = 0; i < widget.vectorSize; ++i) {
      final padding =
          i == 0 ? const EdgeInsets.all(0) : const EdgeInsets.only(top: 10);

      entry.add(Padding(
        padding: padding,
        child: SystemInputField(
          controller: widget.vectorControllers[i],
        ),
      ));
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
    const boxWidth = 65.0;

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
