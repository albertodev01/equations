import 'package:equations_solver/routes/system_page.dart';
import 'package:flutter/material.dart';

/// Wrapper for a series of [TextEditingController]s used by [SystemPage] to
/// handle users inputs.
class SystemTextControllers {
  /// The text input controllers for the matrix.
  ///
  /// This is asking for `A` in the `Ax = b` equation where:
  ///
  ///  - `A` is the matrix
  ///  - `b` is the known values vector
  final List<TextEditingController> matrixControllers;

  /// The text input controllers for the vector.
  ///
  /// This is asking for `b` in the `Ax = b` equation where:
  ///
  ///  - `A` is the matrix
  ///  - `b` is the known values vector
  final List<TextEditingController> vectorControllers;

  /// The text input controllers for the initial guess vector of the Jacobi
  /// algorithm.
  final List<TextEditingController> jacobiControllers;

  /// A controller for the relaxation factor `w` of the SOR algorithm.
  final TextEditingController wSorController;

  /// Creates a [SystemTextControllers] object.
  const SystemTextControllers({
    required this.matrixControllers,
    required this.vectorControllers,
    required this.jacobiControllers,
    required this.wSorController,
  });
}
