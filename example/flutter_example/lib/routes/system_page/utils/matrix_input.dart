import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// Creates an NxN square matrix whose entries are [SystemInputField] widgets.
/// The size of the matrix (`N`) is determined by the length of the controllers
/// list.
class MatrixInput extends StatefulWidget {
  /// The text controllers of the matrix entries.
  final List<TextEditingController> matrixControllers;

  /// The matrix size.
  final int matrixSize;

  /// Creates a [MatrixInput] widget.
  const MatrixInput({
    required this.matrixControllers,
    required this.matrixSize,
    super.key,
  });

  @override
  State<MatrixInput> createState() => _MatrixInputState();
}

class _MatrixInputState extends State<MatrixInput> {
  /// The children of the [Table] widget, representing the matrix.
  late List<TableRow> children = _tableChildren();

  /// Builds the [TableRow]s widget that will allow for the value input.
  List<TableRow> _tableChildren() {
    final rows = <TableRow>[];

    for (var i = 0; i < widget.matrixSize; ++i) {
      final children = <Widget>[];

      for (var j = 0; j < widget.matrixSize; ++j) {
        children.add(
          Padding(
            padding: const EdgeInsets.all(5),
            child: SystemInputField(
              key: Key('SystemEntry-$i-$j'),
              controller: widget.matrixControllers[j + i * widget.matrixSize],
            ),
          ),
        );
      }

      rows.add(
        TableRow(
          children: children,
        ),
      );
    }

    return rows;
  }

  @override
  void didUpdateWidget(covariant MatrixInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matrixSize != oldWidget.matrixSize) {
      children = _tableChildren();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adding '5' to the overall width to make sure that tiles aren't too close.
    final boxWidth = widget.matrixSize * (systemInputFieldSize + 5);

    return Center(
      child: SizedBox(
        width: boxWidth,
        child: Table(
          children: children,
        ),
      ),
    );
  }
}
