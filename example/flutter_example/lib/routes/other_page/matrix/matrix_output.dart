import 'package:equations/equations.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// Creates an NxN square matrix whose entries are [SystemInputField] widgets.
class MatrixOutput extends StatefulWidget {
  /// The matrix to be printed.
  final RealMatrix matrix;

  /// The matrix description.
  final String description;

  /// The precision to use when printing the value. This parameter is passed to
  /// the `toStringAsPrecision(double)` method.
  ///
  /// By default, this is set to 2.
  final int decimalDigits;

  /// Creates a [MatrixOutput] widget.
  const MatrixOutput({
    required this.matrix,
    required this.description,
    this.decimalDigits = 2,
    super.key,
  });

  @override
  State<MatrixOutput> createState() => _MatrixOutputState();
}

class _MatrixOutputState extends State<MatrixOutput> {
  /// Caching the [Text] widget containing the matrix description.
  late final description = Text(
    widget.description,
    style: const TextStyle(
      fontSize: 16,
      color: Colors.blueGrey,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );

  /// The controllers of each [SystemInputField].
  final controllers = List<TextEditingController>.generate(
    16,
    (_) => TextEditingController(),
  );

  /// The [Table] widget representing the matrix.
  late Table table = Table(
    children: _tableChildren(),
  );

  /// Builds the [TableRow] widgets for the matrix values input.
  List<TableRow> _tableChildren() {
    return List<TableRow>.generate(
      widget.matrix.rowCount,
      _createTableRow,
      growable: false,
    );
  }

  /// Builds the row output of the table.
  TableRow _createTableRow(int rowIndex) {
    return TableRow(
      children: List<Widget>.generate(
        widget.matrix.columnCount,
        (index) {
          final value = widget.matrix(rowIndex, index);
          controllers[index].text = value.toStringAsFixed(widget.decimalDigits);

          return Padding(
            padding: const EdgeInsets.all(5),
            child: SystemInputField(
              controller: controllers[index],
              isReadOnly: true,
            ),
          );
        },
        growable: false,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MatrixOutput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matrix != oldWidget.matrix) {
      table = Table(
        children: _tableChildren(),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The description
            description,

            // Some spacing
            const SizedBox(
              height: 10,
            ),

            // The matrix
            SizedBox(
              width: widget.matrix.rowCount * matrixOutputWidth,
              child: table,
            ),
          ],
        ),
      ),
    );
  }
}
