import 'package:equations/equations.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:flutter/material.dart';

/// Creates an NxN square matrix whose entries are [SystemInputField] widgets.
/// The size of the matrix (`N`) is determined by the length of the controllers
/// list.
class MatrixOutput extends StatefulWidget {
  /// The matrix to print.
  final RealMatrix matrix;

  /// The description of the matrix.
  final String description;

  /// The precision to use when printing the value. This parameter is passed to
  /// the `toStringAsPrecision(double)` method.
  ///
  /// By default, this is set to 2.
  final int decimalDigits;

  /// Creates a [MatrixOutput] widget.
  const MatrixOutput({
    super.key,
    required this.matrix,
    required this.description,
    this.decimalDigits = 2,
  });

  @override
  _MatrixOutputState createState() => _MatrixOutputState();
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

  /// The children of the [Table] widget, representing the matrix.
  late List<TableRow> children = _tableChildren();

  /// Builds the [TableRow]s widget that will allow for the value input.
  List<TableRow> _tableChildren() {
    final rows = <TableRow>[];

    for (var i = 0; i < widget.matrix.rowCount; ++i) {
      final children = <Widget>[];

      for (var j = 0; j < widget.matrix.columnCount; ++j) {
        final value = widget.matrix(i, j);
        children.add(
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              readOnly: true,
              initialValue: value.toStringAsFixed(widget.decimalDigits),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 3,
                ),
              ),
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
  void didUpdateWidget(covariant MatrixOutput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matrix != oldWidget.matrix) {
      children = _tableChildren();
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxWidth = widget.matrix.rowCount * 70.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Center(
        child: SizedBox(
          width: boxWidth,
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
              Table(
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
